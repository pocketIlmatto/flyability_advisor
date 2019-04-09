include Geokit::Geocoders

class HomeController < ApplicationController
  
  def index
    # Default location for first time load
    @lat = 37.804829
    @lng = -122.272476

    user_location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    Rails.logger.info "event=ip_address_reverese_geocode_lookup ip=#{request.remote_ip}"
    if user_location.success
      @lat = user_location.lat
      @lng = user_location.lng
    end
    
    # Get the sites within range, and sort the ids
    bounds = Geokit::Bounds.from_point_and_radius([@lat, @lng], 150)
    fly_site_ids = FlySite.in_bounds(bounds).sort_by{|f| f.distance_to([@lat, @lng])}.pluck(:id)
 
    # @fly_sites needs to be ActiveRecord::Relation for pagination to work correctly
    @fly_sites = FlySite.for_ids_with_order(fly_site_ids).includes([:latest_flyability_score])

    @fly_sites = @fly_sites.page(params[:page] ? params[:page] : 1)

    @fly_sites_gmaps_json = @fly_sites.pluck(:lat, :lng, :name, :slug).to_json
    @fly_sites
  end

private

  def fly_site_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end

end
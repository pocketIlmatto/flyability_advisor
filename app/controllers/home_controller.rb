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
    bounds = Geokit::Bounds.from_point_and_radius([@lat, @lng], 150)
    @fly_sites = FlySite.includes([:latest_flyability_score]).in_bounds(bounds)

    @fly_sites = @fly_sites.sort_by{|f| f.distance_to([@lat, @lng])}

    page_start = params[:page] ? (params[:page][:number] * FlySite.per_page) : 0
    page_end = params[:page] ? ((params[:page][:number] + 1) * FlySite.per_page) : FlySite.per_page
    
    @fly_sites = @fly_sites[page_start, page_end]
    @fly_sites_gmaps_json = @fly_sites.pluck(:lat, :lng, :name, :slug).to_json
    @fly_sites
  end

private

  def fly_site_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end

end
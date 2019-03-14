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
    @fly_sites = FlySite.within(4000, 
      origin: [@lat, @lng]).includes(:latest_flyability_score)

    @fly_sites = @fly_sites.page(params[:page] ? params[:page][:number] : 1)
  end

private

  def fly_site_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end

end
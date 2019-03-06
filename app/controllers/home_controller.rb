include Geokit::Geocoders

class HomeController < ApplicationController

  def index
    user_location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    Rails.logger.info "event=ip_address_reverese_geocode_lookup ip=#{request.remote_ip}"
    if user_location.success
      @fly_sites = FlySite.within(40, 
        origin: [user_location.lat, user_location.lng])
    else
      @fly_sites = FlySite.all
    end

    @fly_sites = @fly_sites.page(params[:page] ? params[:page][:number] : 1)
  end

private

  def fly_site_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end

end
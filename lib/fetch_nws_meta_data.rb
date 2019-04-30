class FetchNWSMetaData

  def self.call(lat, lng)
    nws_url = "https://api.weather.gov/points/#{lat},#{lng}"
    nws_meta_data = {}
    begin
      response = RestClient.get(nws_url)
      data = JSON.parse( response.body )
      nws_meta_data = {properties: data["properties"]}

      # Pull the forecast_zone out of the url for ease of use elsewhere
      forecast_zone_match = data["properties"]["forecastZone"].match(/forecast\/(.*)$/)
      if !forecast_zone_match.nil? && forecast_zone_match.length > 1
        nws_meta_data.merge!(forecastZone: forecast_zone_match[1])
      end
    rescue
      puts "Could not fetch nws metadata for: #{lat}, #{lng}"
    end
    nws_meta_data
  end

end


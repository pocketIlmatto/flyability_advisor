module GetForecast

  class NWS

    SOURCE = 'NWS'
    TTL_HOURS = 8

    def self.call(fly_site)
      if !fly_site.lat || !fly_site.lng
        Rails.logger.info "Cannot fetch forecast for site without GPS coordinates"
        return
      end

      forecast = ::Forecast.where(fly_site_id: fly_site.id, source: SOURCE)
        .where("data_updated_at >= ?", Time.zone.now.utc - TTL_HOURS.hours).first
      if forecast
        Rails.logger.info "Forecast found for #{fly_site.slug}. Skipping external API call."
        return
      end

      begin
        nws_url = "https://api.weather.gov/points/#{fly_site.lat},#{fly_site.lng}/forecast/hourly"
        response = RestClient.get(nws_url)
        data = JSON.parse( response.body )

        data = data["properties"]
        forecast = ::Forecast.find_or_initialize_by(fly_site_id: fly_site.id,
          data_updated_at: data["updated"], source: SOURCE)

        unless forecast.new_record?
          Rails.logger.info "Forecast found for #{fly_site.slug}. Check TTL"
          return
        end

        forecast.data = data
        forecast.save!
        Rails.logger.info "Forecast saved for #{fly_site.slug}"
      rescue => error
        Rails.logger.warn "Could not update forecast for #{fly_site.id}: #{error}"
      end

    end

  end

end
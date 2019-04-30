module ProcessIntoHourlyForecasts

  class NWS
    
    SOURCE = 'NWS'

    def self.call(fly_site)
      forecast = ::Forecast.where(source: SOURCE, fly_site_id: fly_site.id)
        .order(data_updated_at: :desc).first

      unless forecast
        Rails.logger.warn "Forecast not found for #{fly_site.slug}."
        return
      end

      begin
        data = forecast.data

        # Assumes that each period is for 1 hour, which should be true for this 
        # NWS product
        data["periods"].each do |period|
          start_hour = Time.parse(period["startTime"]).change(min: 0)
          hourly_forecast = ::HourlyForecast.find_or_initialize_by(
            fly_site_id: fly_site.id, source: SOURCE, start_time: start_hour)
          hourly_forecast.data_updated_at = data["updated"]
          hourly_forecast.data = period
          hourly_forecast.save!
          Rails.logger.info "Forecast saved for #{fly_site.slug}"
        end
      rescue => error
        Rails.logger.warn "Could not update forecast for #{fly_site.id}: " +
          "#{error}"
      end

    end

  end

end
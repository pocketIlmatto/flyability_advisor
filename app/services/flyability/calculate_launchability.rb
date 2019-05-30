module Flyability

  class CalculateLaunchability

    CALCULATION_VERSION = '2.0.0'

    def self.call(fly_site, hourly_forecast)
      if hourly_forecast.source == 'NWS'
        return nws(fly_site, hourly_forecast)
      else
        return 'no'
      end
    end

    def self.nws(fly_site, hourly_forecast)
      data = hourly_forecast.data
      time_hour = hourly_forecast.start_time
        .in_time_zone("Pacific Time (US & Canada)").hour

      if time_hour <= fly_site.hourstart || time_hour >= fly_site.hourend
        return 'not_in_flying_window'
      end

      short_forecast_no_gos = ['Rain Showers', 'Chance Rain Showers']

      speed_min_act = data['speed_min_act']
      speed_max_act = data['speed_max_act']

      wind_direction = data['windDirection']
      short_forecast = data['shortForecast']

      score = ''
      if short_forecast_no_gos.include?(short_forecast)
        return 0
      end

      unless fly_site.dir_edge.include?(wind_direction)
        return 0
      end

      speed_score = 0
      if speed_min_act >= fly_site.speedmin_ideal &&
        speed_max_act <= fly_site.speedmax_ideal
        speed_score = 2
      elsif speed_min_act >= fly_site.speedmin_edge &&
        speed_max_act <= fly_site.speedmax_edge
        speed_score = 1 if speed_min_act <= fly_site.speedmin_ideal
        speed_score = 3 if speed_max_act >= fly_site.speedmax_ideal
      else
        return 0
      end

      if fly_site.dir_ideal.include?(wind_direction)
        return speed_score
      else
        return speed_score + 3
      end

      score
    end
  end
end
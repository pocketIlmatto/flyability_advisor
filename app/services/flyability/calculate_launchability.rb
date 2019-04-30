module Flyability

  class CalculateLaunchability

    CALCULATION_VERSION = '1.0.0'

    def self.call(fly_site, hourly_forecast)
      if hourly_forecast.source == 'NWS'
        return nws(fly_site, hourly_forecast)
      else
        return 'no'
      end
    end

    def self.nws(fly_site, hourly_forecast)
      data = hourly_forecast.data

      return 'not_in_flying_window' unless data['isDaytime']

      short_forecast_no_gos = ['Rain Showers', 'Chance Rain Showers']
      
      wind_speed = data['windSpeed']
      speed_min_act = 0
      speed_max_act = 0
      if wind_speed.length < 7
        speed_min_act = wind_speed[0, wind_speed.index('mph')]
        speed_max_act = wind_speed[0, wind_speed.index('mph')]
      else
        speed_min_act = wind_speed[0, wind_speed.index('to')]
        speed_max_act = wind_speed.match(/to(.*)mph/)[1]
      end
      speed_min_act = speed_min_act.try(:strip).try(:to_i)
      speed_max_act = speed_max_act.try(:strip).try(:to_i)

      wind_direction = data['windDirection']
      short_forecast = data['shortForecast']

      score = ''
      if speed_min_act >= fly_site.speedmin_ideal &&
        speed_max_act <= fly_site.speedmax_ideal &&
        fly_site.dir_ideal.include?(wind_direction) &&
        !short_forecast_no_gos.include?(short_forecast)
        score = 'ideal'
      elsif speed_min_act >= fly_site.speedmin_edge && 
        speed_max_act <= fly_site.speedmax_edge &&
        fly_site.dir_edge.include?(wind_direction)
        !short_forecast_no_gos.include?(short_forecast)
        score = 'edge'
      else
        score = 'no'
      end
    
      score
    end
  end   
end
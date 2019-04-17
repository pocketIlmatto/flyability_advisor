class CalculateFlyabilityScores

  # 1.0.1 Uses the short forecast to determine precipitation levels
  CALCULATION_VERSION = '1.0.1'

  def self.calculate(fly_site)
    ideal_count = 0
    maybe_count = 0
    scores = Hash.new(0)
    score_details = {}
    short_forecast_no_gos = ["Rain Showers", "Chance Rain Showers"]

    todaynum = Time.now.wday

    nws_forecast = ::Forecast.where(source: 'NWS', fly_site_id: fly_site.id)
      .order(data_updated_at: :desc).first

    if !nws_forecast || !nws_forecast.data["periods"]
      Rails.logger.info "NWS forecast missing for #{fly_site.slug}. Cannot calculate scores at this time."
      return
    end

    nws_data = nws_forecast.data

    for i in 0..155
      period_data = nws_data["periods"][i]
      
      time_hour = Time.parse(period_data["startTime"]).hour
      score_details[todaynum] = {} if i == 0

      wind_speed = period_data["windSpeed"]
      speed_min_act = 0
      speed_max_act = 0
      if wind_speed.length < 7
        speed_min_act = wind_speed[0, wind_speed.index("mph")]
        speed_max_act = wind_speed[0, wind_speed.index("mph")]
      else
        speed_min_act = wind_speed[0, wind_speed.index("to")]
        speed_max_act = wind_speed.match(/to(.*)mph/)[1]
      end
      speed_min_act = speed_min_act.try(:strip).try(:to_i)
      speed_max_act = speed_max_act.try(:strip).try(:to_i)

      wind_direction = period_data["windDirection"]
      short_forecast = period_data["shortForecast"]

      # Starting new day, so total up the scores
      if time_hour == 0
        if ideal_count >= 3
          scores[todaynum] = "hell-yes"
        elsif ideal_count >= 1
          scores[todaynum] = "go"
        elsif maybe_count >= 3
          scores[todaynum] = "maybe"
        else
          scores[todaynum] = "no"
        end
        
        todaynum += 1
        score_details[todaynum] = {} 
        
        ideal_count = 0
        maybe_count = 0
      end

      score_details[todaynum][time_hour] = {
        icon: period_data["icon"],
        short_forecast: short_forecast,
        speed_min_act: speed_min_act,
        speed_max_act: speed_max_act,
        wind_direction: wind_direction,
        wind_speed: wind_speed
      }
      
      if time_hour >= fly_site.hourstart && time_hour <= fly_site.hourend
        if speed_min_act >= fly_site.speedmin_ideal &&
          speed_max_act <= fly_site.speedmax_ideal &&
          fly_site.dir_ideal.include?(wind_direction) &&
          !short_forecast_no_gos.include?(short_forecast)
          score_details[todaynum][time_hour][:score] = 'ideal'
          ideal_count += 1
          maybe_count += 1
        elsif speed_min_act >= fly_site.speedmin_edge && 
          speed_max_act <= fly_site.speedmax_edge &&
          fly_site.dir_edge.include?(wind_direction)
          !short_forecast_no_gos.include?(short_forecast)
          score_details[todaynum][time_hour][:score] = 'edge'
          maybe_count += 1
        else
          score_details[todaynum][time_hour][:score] = 'no'
        end
      else
        score_details[todaynum][time_hour][:score] = 'not_in_flying_window'
      end
    end
    
    ::FlyabilityScore.create(calculation_version: CALCULATION_VERSION, 
      fly_site_id: fly_site.id, scores: scores, score_details: score_details)
    Rails.logger.info "Flyability scores calculated for #{fly_site.slug}"
  end

end


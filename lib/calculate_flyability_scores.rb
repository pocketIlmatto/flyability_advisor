class CalculateFlyabilityScores

  CALCULATION_VERSION = '1.0.0'

  def self.calculate(fly_site)
    ideal_count = 0
    maybe_count = 0
    scores = Hash.new(0)

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
      time_str = period_data["startTime"]
      time_hour = time_str[11,3].strip.to_i
      is_utc = time_str[20,2]
      if is_utc == '00'
        time_hour = time_hour - 7 # TODO don't hard-code this timezone fix
        if (time_hour < 0)
          time_hour = time_hour + 24
        end
      end

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

      if time_hour == 0
        # Starting new day, so total up the scores
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
        
        ideal_count = 0
        maybe_count = 0
      elsif time_hour >= fly_site.hourstart && time_hour <= fly_site.hourend
        if speed_min_act >= fly_site.speedmin_ideal &&
          speed_max_act <= fly_site.speedmax_ideal &&
          fly_site.dir_ideal.include?(wind_direction)
          ideal_count += 1
          maybe_count += 1
        elsif speed_min_act >= fly_site.speedmin_edge && 
          speed_max_act <= fly_site.speedmax_edge &&
          fly_site.dir_edge.include?(wind_direction)
          maybe_count += 1
        end
      end
    end
    
    ::FlyabilityScore.create(calculation_version: CALCULATION_VERSION, 
      fly_site_id: fly_site.id, scores: scores)
    Rails.logger.info "Flyability scores calculated for #{fly_site.slug}"
  end

end
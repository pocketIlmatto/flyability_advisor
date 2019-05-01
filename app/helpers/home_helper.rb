module HomeHelper
  DOW_MAP = {"0" => "Su", "1" => "M", "2" => "Tu", "3" => "W", "4" => "Th", "5" => "F", "6" => "Sa"}

  def get_dow(wkday)
    wkday = wkday.to_i % 7
    DOW_MAP[wkday.to_s]
  end

  def get_score_css_class(score)
    case score
    when "hell-yes"
      "bg-success"
    when "go"
      "bg-info"
    when "maybe"
      "bg-warning"
    else
      "bg-secondary"
    end
  end

  def get_directional_arrow_class(direction)
    case direction
    when "SSE"
      "rotate-337.5"
    when "SE"
      "rotate-315"
    when "ESE"
      "rotate-292.5"
    when "E"
      "rotate-270"
    when "ENE"
      "rotate-247.5"
    when "NE"
      "rotate-225"
    when "NNE"
      "rotate-202.5"
    when "N"
      "rotate-180"
    when "NNW"
      "rotate-157.5"
    when "NW"
      "rotate-135"
    when "WNW"
      "rotate-112.5"
    when "W"
      "rotate-90"
    when "WSW"
      "rotate-67.5"
    when "SW"
      "rotate-45"
    when "SSW"
      "rotate-22.5"
    when "S"
      ""
    else
      "spin"
    end
  end

  def translate_score_details_for_display(fly_site, days_ahead)
    scores = fly_site.hourly_flyability_scores.current
      .by_days_ahead(days_ahead, "Pacific Time (US & Canada)")
    
    scores = scores.reject { |s| s.scores['launchability'] == 'not_in_flying_window' }

    forecasts = fly_site.hourly_forecasts.current.where(start_time: scores.map { |s| s.start_time} )
  
    display_details = {
      scores: scores.map { |hf| hf.scores['launchability']}, 
      hours: scores.map { |hf| hf.start_time.in_time_zone("Pacific Time (US & Canada)").hour }, 
      speeds: forecasts.map { |hf| hf.data["speed_max_act"] }, 
      directions: forecasts.map { |hf| get_directional_arrow_class(hf.data["windDirection"]) }
    }
  end
end
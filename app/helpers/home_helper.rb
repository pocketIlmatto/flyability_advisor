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

  def translate_score_details_for_display(score_details_dow)
    display_details = {scores: [], hours: [], speeds: [], directions: []}
    score_details_dow.each_pair do |hour, score_details_dow_hour|
      next if score_details_dow_hour["score"] == "not_in_flying_window"
      display_details[:hours] << hour
      display_details[:scores] << score_details_dow_hour["score"]
      display_details[:speeds] << score_details_dow_hour["speed_max_act"]
      display_details[:directions] << get_directional_arrow_class(score_details_dow_hour["wind_direction"])
    end
    display_details
  end
end
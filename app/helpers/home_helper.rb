module HomeHelper
  DOW_MAP = {"0" => "Su", "1" => "M", "2" => "Tu", "3" => "W", "4" => "Th", "5" => "F", "6" => "Sa"}

  def get_dow(wkday)
    wkday = (wkday.to_i - 7).to_s if wkday.to_i >= 7
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

  def translate_score_details_for_display(score_details_dow)
    display_details = {scores: [], hours: [], speeds: [], directions: [], icons: []}
    score_details_dow.each_pair do |hour, score_details_dow_hour|
      next if score_details_dow_hour["score"] == "not_in_flying_window"
      display_details[:hours] << hour
      display_details[:scores] << score_details_dow_hour["score"]
      display_details[:speeds] << score_details_dow_hour["speed_max_act"]
      display_details[:directions] << score_details_dow_hour["wind_direction"]
      display_details[:icons] << score_details_dow_hour["icon"]
    end
    display_details
  end
end
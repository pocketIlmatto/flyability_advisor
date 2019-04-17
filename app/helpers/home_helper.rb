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
end
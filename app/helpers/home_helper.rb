module HomeHelper
  DOW_MAP = {"0" => "Su", "1" => "Mo", "2" => "Tu", "3" => "We", "4" => "Th", "5" => "Fr", "6" => "Sa"}

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
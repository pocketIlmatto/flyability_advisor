module HomeHelper
  DOW_MAP = {"0" => "Su", "1" => "Mo", "2" => "Tu", "3" => "We", "4" => "Th", "5" => "Fr", "6" => "Sa"}

  def get_dow(wkday)
    wkday = (wkday.to_i - 7).to_s if wkday.to_i >= 7
    DOW_MAP[wkday]
  end

  def get_score_css_class(score)
    case score
    when "hell-yes"
      "btn-success"
    when "go"
      "btn-info"
    when "maybe"
      "btn-warning"
    else
      "btn-secondary"
    end
  end
end
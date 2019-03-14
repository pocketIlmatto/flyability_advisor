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

  def nws_plotter_url(fly_site)
    url = "https://forecast.weather.gov/meteograms/Plotter.php?" +
      "lat=#{fly_site.lat}&lon=#{fly_site.lng}&wfo=#{fly_site.nws_meta_data[:properties][:cwa]}&" +
      "zcode=#{fly_site.nws_meta_data[:forecastZone]}&gset=18&gdiff=3&unit=0&tinfo=PY8" +
      "&ahour=0&pcmd=00001110000000000000000000000000000000000000000000000000000" +
      "&lg=en&indu=1!1!1!&dd=&bw=&hrspan=48&pqpfhr=6&psnwhr=6"
  end
end
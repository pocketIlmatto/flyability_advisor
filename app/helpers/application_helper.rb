module ApplicationHelper
  def nws_plotter_url(fly_site, with_temp = false)
    pcmd = with_temp ? '10001110000000000000000000000000000000000000000000000000000' : '00001110000000000000000000000000000000000000000000000000000'
    url = "https://forecast.weather.gov/meteograms/Plotter.php?" +
      "lat=#{fly_site.lat}&lon=#{fly_site.lng}&wfo=#{fly_site.nws_meta_data[:properties][:cwa]}&" +
      "zcode=#{fly_site.nws_meta_data[:forecastZone]}&gset=18&gdiff=3&unit=0&tinfo=PY8" +
      "&ahour=0&pcmd=#{pcmd}&lg=en&indu=1!1!1!&dd=&bw=&hrspan=48&pqpfhr=6&psnwhr=6"
  end
end

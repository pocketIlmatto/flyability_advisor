namespace :forecasts do

  namespace :nws do

    desc 'Get the latest NWS forecast for all sites'
    task get_all_forecasts: [:environment] do
      puts "event=rake_task_started task=forecasts:nws:get_all_forecasts time=#{Time.zone.now.utc} UTC"
      FlySite.all.each do |fly_site|
        GetForecast::NWS.call(fly_site)
        sleep(1)
      end
      puts "event=rake_task_finished task=forecasts:nws:get_all_forecasts time=#{Time.zone.now.utc} UTC"
    end

    desc 'Process the latest NWS forecast for all sites'
    task process_all_into_hourly_forecasts: [:environment] do
      puts "event=rake_task_started task=forecasts:nws:process_all_into_hourly_forecasts time=#{Time.zone.now.utc} UTC"
      FlySite.all.each do |fly_site|
        ProcessIntoHourlyForecasts::NWS.call(fly_site)
      end
      puts "event=rake_task_finished task=forecasts:nws:process_all_into_hourly_forecasts time=#{Time.zone.now.utc} UTC"
    end

  end

end

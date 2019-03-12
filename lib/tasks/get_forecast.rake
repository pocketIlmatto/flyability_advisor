namespace :forecasts do
  
  namespace :nws do

    desc 'Get the latest NWS forecast'
    task get_all: [:environment] do
      puts "event=rake_task_started task=forecasts:nws:get_all time=#{Time.now.utc} UTC"
      FlySite.all.each do |fly_site|
        GetForecast::NWS.fetch(fly_site)
        sleep(1)
      end
      puts "event=rake_task_finished task=forecasts:nws:get_all time=#{Time.now.utc} UTC"
    end

  end

end

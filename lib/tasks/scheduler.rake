desc "This task is called by the Heroku scheduler add-on"
task :fetch_forecasts => :environment do
  puts "event=rake_task_started task=forecasts:nws:get_all_forecasts time=#{Time.now.utc} UTC"
  FlySite.all.each do |fly_site|
    GetForecast::NWS.call(fly_site)
    sleep(0.25) # Avoid rate limits
  end
  puts "event=rake_task_finished task=forecasts:nws:get_all_forecasts time=#{Time.now.utc} UTC"
end

task :process_into_hourly_forecasts => :environment do
  puts "event=rake_task_started task=forecasts:nws:process_all_into_hourly_forecasts time=#{Time.now.utc} UTC"
  FlySite.all.each do |fly_site|
    ProcessIntoHourlyForecasts::NWS.call(fly_site)
  end
  puts "event=rake_task_finished task=forecasts:nws:process_all_into_hourly_forecasts time=#{Time.now.utc} UTC"
end

task :generate_hourly_flyability_scores => :environment do
  puts "event=rake_task_started task=flyability_scores:generate_all time=#{Time.now.utc} UTC"
  FlySite.all.each do |fly_site|
    GenerateHourlyFlyabilityScores::call(fly_site)
  end
  puts "event=rake_task_finished task=flyability_scores:generate_all time=#{Time.now.utc} UTC"
end

task :heroku_clean_up_old_data => :environment do
  cutoff_time = Time.now.beginning_of_day.utc - 5.days
  puts "event=rake_task_started task=heroku_clean_up_old_data time=#{Time.now.utc} UTC"
  Forecast.where("updated_at <= ?", cutoff_time).delete_all
  HourlyForecast.where("updated_at <= ?", cutoff_time).delete_all
  HourlyFlyabilityScore.where("updated_at <= ?", cutoff_time).delete_all
  puts "event=rake_task_finished task=heroku_clean_up_old_data time=#{Time.now.utc} UTC"
  
end
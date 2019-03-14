desc "This task is called by the Heroku scheduler add-on"
task :fetch_forecasts => :environment do
  puts "event=rake_task_started task=forecasts:nws:get_all time=#{Time.now.utc} UTC"
  FlySite.all.each do |fly_site|
    GetForecast::NWS.fetch(fly_site)
    sleep(0.25) # Avoid rate limits
  end
  puts "event=rake_task_finished task=forecasts:nws:get_all time=#{Time.now.utc} UTC"
end

task :calculate_flyability_scores => :environment do
  puts "event=rake_task_started task=flyability:calculate_all time=#{Time.now.utc} UTC"
  FlySite.all.each do |fly_site|
    CalculateFlyabilityScores::calculate(fly_site)
  end
  puts "event=rake_task_ended task=flyability:calculate_all time=#{Time.now.utc} UTC"
end
namespace :flyability do
  
  desc 'Calculate flyability scores for all fly sites'
  task calculate_all: [:environment] do
    puts "event=rake_task_started task=flyability:calculate_all time=#{Time.now.utc} UTC"
    FlySite.all.each do |fly_site|
      CalculateFlyabilityScores::calculate(fly_site)
    end
    puts "event=rake_task_ended task=flyability:calculate_all time=#{Time.now.utc} UTC"
  end

end

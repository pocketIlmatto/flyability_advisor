namespace :flyability_scores do

  desc 'Generate flyability scores for all fly sites'
  task generate_all: [:environment] do
    puts "event=rake_task_started task=flyability_scores:generate_all time=#{Time.now.utc} UTC"
    FlySite.all.each do |fly_site|
      GenerateHourlyFlyabilityScores::call(fly_site)
    end
    puts "event=rake_task_ended task=flyability_scores:generate_all time=#{Time.now.utc} UTC"
  end

end
namespace :maintenance do

  task clean_up_old_data: [:environment] do
    cutoff_time = Time.now.beginning_of_day.utc - 5.days
    puts "event=rake_task_started task=maintenance:clean_up_old_data time=#{Time.now.utc} UTC"
    Forecast.where("updated_at <= ?", cutoff_time).delete_all
    HourlyForecast.where("updated_at <= ?", cutoff_time).delete_all
    HourlyFlyabilityScore.where("updated_at <= ?", cutoff_time).delete_all
    puts "event=rake_task_finished task=maintenance:clean_up_old_data time=#{Time.now.utc} UTC"
  end

end
class GenerateHourlyFlyabilityScores

  def self.call(fly_site)
    fly_site.hourly_forecasts.current.each do |hourly_forecast|
      hourly_flyability_score = ::HourlyFlyabilityScore.find_or_initialize_by(
        fly_site_id: fly_site.id, start_time: hourly_forecast.start_time)

      # Call each of the score calculators - for now, only 1
      hourly_flyability_score.scores[:launchability] = 
        Flyability::CalculateLaunchability.call(fly_site, hourly_forecast)
      
      hourly_flyability_score.scores_will_change!
      hourly_flyability_score.save!
    end
  end

end
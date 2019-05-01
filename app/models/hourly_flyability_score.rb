class HourlyFlyabilityScore < ApplicationRecord
  scope :current, -> do 
    where("start_time >= ?", Time.now.utc.change(min: 0))
    .order(start_time: :asc)
  end
  
  scope :by_days_ahead, -> num_days, time_zone do
    where("start_time >= ? AND start_time <= ?", 
      (Time.now.in_time_zone(time_zone).beginning_of_day.utc + num_days.days), 
      ((Time.now.in_time_zone(time_zone).end_of_day.utc + num_days.days)))
    .order(start_time: :asc)
  end
end

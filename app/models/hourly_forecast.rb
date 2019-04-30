class HourlyForecast < ApplicationRecord
  scope :current, lambda { where("start_time >= ?", Time.now.change(min: 0)) }
end

class FlySite < ApplicationRecord
  acts_as_mappable :default_units => :miles,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
  self.per_page = 10

  has_many :flyability_scores
  has_one :latest_flyability_score, -> { order 'updated_at' }, class_name: "FlyabilityScore"
end

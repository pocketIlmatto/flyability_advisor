class FlySite < ApplicationRecord
  acts_as_mappable :default_units => :miles,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
  self.per_page = 15

  scope :for_ids_with_order, ->(ids) {
    order = sanitize_sql_array(
      ["position((',' || fly_sites.id::text || ',') in ?)", ids.join(',') + ',']
    )
    where('fly_sites.id IN (?)', ids).order(order)
  } 

  has_and_belongs_to_many :users, -> { distinct }
  has_many :flyability_scores
  has_many :hourly_forecasts
  has_one :latest_flyability_score, -> { order(updated_at: :desc) }, class_name: "FlyabilityScore"

  serialize :nws_meta_data, JSONBSerializeWithIndifferentAccess

  store_accessor :nws_meta_data, :forecastZone

  before_create :populate_nws_meta_data
  
private
  def populate_nws_meta_data
    self.nws_meta_data = FetchNWSMetaData.call(lat, lng)
  end
end

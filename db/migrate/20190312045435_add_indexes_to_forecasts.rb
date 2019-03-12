class AddIndexesToForecasts < ActiveRecord::Migration[5.2]
  def change
    add_index :forecasts, [:source, :fly_site_id, :data_updated_at]
  end
end

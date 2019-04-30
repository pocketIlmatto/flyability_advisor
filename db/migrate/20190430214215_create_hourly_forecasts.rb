class CreateHourlyForecasts < ActiveRecord::Migration[5.2]
  
  def change
    create_table :hourly_forecasts do |t|
      t.references :fly_site
      t.string :source
      t.datetime :data_updated_at
      t.datetime :start_time 
      t.jsonb :data, null: false, default: '{}'

      t.timestamps
    end

    add_index :hourly_forecasts, [:source, :fly_site_id, :start_time], unique: true
  end

end

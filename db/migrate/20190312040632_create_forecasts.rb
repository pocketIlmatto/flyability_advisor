class CreateForecasts < ActiveRecord::Migration[5.2]
  def change
    create_table :forecasts do |t|
      t.references :fly_site
      t.string :source
      t.datetime :data_updated_at 
      t.jsonb :data, null: false, default: '{}'

      t.timestamps
    end
  end
end

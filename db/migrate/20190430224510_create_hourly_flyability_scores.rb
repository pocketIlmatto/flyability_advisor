class CreateHourlyFlyabilityScores < ActiveRecord::Migration[5.2]
  def change
    create_table :hourly_flyability_scores do |t|
      t.references :fly_site
      t.datetime :start_time 
      t.jsonb :scores, default: {}, null: false
      
      t.timestamps
    end

    add_index :hourly_flyability_scores, [:fly_site_id, :start_time],
      unique: true, name: 'idx_hourly_flyability_scores_fly_site_id_start_time'
  end
end

class CreateFlyabilityScores < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore'

    create_table :flyability_scores do |t|
      t.references :fly_site
      t.hstore :scores, default: {}, null: false
      t.string :calculation_version

      t.timestamps
    end
  end
end

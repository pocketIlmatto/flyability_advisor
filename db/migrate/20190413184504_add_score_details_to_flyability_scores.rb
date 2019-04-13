class AddScoreDetailsToFlyabilityScores < ActiveRecord::Migration[5.2]
  
  def change
    add_column :flyability_scores, :score_details, :jsonb, default: {}
  end
  
end

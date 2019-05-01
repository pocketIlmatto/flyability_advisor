class DropFlyabilityScores < ActiveRecord::Migration[5.2]
  def change
    drop_table :flyability_scores
  end
end

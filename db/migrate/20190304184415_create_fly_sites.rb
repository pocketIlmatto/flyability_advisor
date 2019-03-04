class CreateFlySites < ActiveRecord::Migration[5.2]
  def change
    create_table :fly_sites do |t|
      t.string :name
      t.string :slug
      t.decimal :lat
      t.decimal :lng
      t.integer :hourstart
      t.integer :hourend
      t.integer :speedmin_ideal
      t.integer :speedmax_ideal
      t.integer :speedmin_edge
      t.integer :speedmax_edge
      t.string :dir_ideal, array: true
      t.string :dir_edge, array: true

      t.timestamps
    end
  end
end

class AddNwsColumnsToFlySites < ActiveRecord::Migration[5.2]
  def change
    add_column :fly_sites, :nws_meta_data, :jsonb, default: {}
  end
end

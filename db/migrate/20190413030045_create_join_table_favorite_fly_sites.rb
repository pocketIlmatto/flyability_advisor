class CreateJoinTableFavoriteFlySites < ActiveRecord::Migration[5.2]
  
  def change
    create_join_table :fly_sites, :users, table_name: :fly_sites_users do |t|
      t.timestamps
    end
    add_index :fly_sites_users, :fly_site_id
    add_index :fly_sites_users, :user_id
  end
end

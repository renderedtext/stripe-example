class CreateRailsAdminHistoriesTable < ActiveRecord::Migration

   def change
     create_table :rails_admin_histories do |t|
       t.integer :item
       t.integer :month, limit: 2
       t.integer :year,  limit: 5
       t.string  :table
       t.string  :username
       t.text    :message # title, name, or object_id

       t.timestamps
    end

    add_index :rails_admin_histories, [:item, :table, :month, :year], name: 'index_rails_admin_histories'
  end

end

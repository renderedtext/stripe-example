class CreateRailsAdminHistoriesTable < ActiveRecord::Migration

   def change
     create_table :rails_admin_histories do |t|
       t.integer :item
       t.integer :month
       t.integer :year
       t.string  :table
       t.string  :username
       t.text    :message # title, name, or object_id

       t.timestamps
    end

    add_index :rails_admin_histories, [:item, :table, :month, :year], name: 'index_rails_admin_histories'
  end

end

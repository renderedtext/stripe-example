class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :name
      t.string  :description
      t.decimal :price, null: false, precision: 8, scale: 2

      t.timestamps
    end
  end
end

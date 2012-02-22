class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string  :name
      t.string  :description
      t.decimal :price, null: false, precision: 8, scale: 2

      t.timestamps
    end
  end
end

class CreatePlans < ActiveRecord::Migration

  def change
    create_table :plans do |t|
      t.string  :name,  null: false
      t.string  :slug,  null: false
      t.decimal :price, null: false, precision: 8, scale: 2

      t.timestamps
    end

    add_index :plans, :slug, unique: true
    add_index :plans, :price
  end

end
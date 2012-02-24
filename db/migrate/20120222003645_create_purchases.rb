class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :item
      t.belongs_to :user
      t.boolean    :live,                default: false
      t.boolean    :paid,                default: false
      t.boolean    :refunded,            default: false
      t.decimal    :price,               precision: 8,   scale: 2, null: false
      t.integer    :fee
      t.string     :card_type
      t.string     :card_zip
      t.string     :last_four
      t.string     :stripe_charge_token

      t.timestamps
    end
  end
end

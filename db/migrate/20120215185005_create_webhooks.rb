class CreateWebhooks < ActiveRecord::Migration

  def change
    create_table :webhooks do |t|
      t.belongs_to :user

      t.string  :stripe_webhook_id,   null:    false 
      t.string  :stripe_webhook_type, null:    false 
      t.text    :object,              null:    false 
      t.boolean :livemode,            default: false 

      t.timestamps
    end

    add_index :webhooks, :stripe_webhook_id, unique: true
    add_index :webhooks, :user_id
  end

end

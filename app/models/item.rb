class Item < ActiveRecord::Base
  has_many :purchases
  has_many :users, through: :purchases

  def purchase user, stripe_card_token
    purchase = Purchase.new( :user => user, :item => this.id )
    purchase.stripe_card_token = stripe_card_token

    return purchase.save_with_payment
  end
end

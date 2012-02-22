class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  def save_with_payment stripe_card_token
    binding.pry
    charge = Stripe::Charge.create amount:      (item.price * 100).to_i,
                                   card:        stripe_card_token,
                                   currency:    'usd',
                                   description: "#{ user.email } purchased #{ item.name }"

    card = charge.card

    # save the charge id
    self.stripe_charge_token = charge.id

    # cache charge info
    self.fee      = charge.fee
    self.live     = charge.livemode
    self.paid     = charge.paid
    self.refunded = charge.refunded

    # cache card info
    self.card_type = card.type
    self.last_four = card.last4

    # save the purchase price
    self.price = item.price

    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }" 
    errors[:base] << "Unable to process your credit card!"
    false
  end

end

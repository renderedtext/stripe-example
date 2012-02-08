class Subscription < ActiveRecord::Base

  attr_accessor :stripe_card_token

  belongs_to :plan
  belongs_to :user

  validates :plan_id,               presence: true
  validates :user_id,               presence: true, uniqueness: true
  validates :stripe_customer_token, presence: true

  def save_with_payment
    customer = Stripe::Customer.create email: user.email, plan: plan.slug, card: stripe_card_token
    card = customer.active_card

    self.stripe_customer_token = customer.id
    self.last_four             = card.last4
    self.card_type             = card.type
    self.next_bill_on          = Date.parse customer.next_recurring_charge.date
    self.card_expiration       = "#{card.exp_month}-#{card.exp_year}"
    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }"
    errors[:base] << "Unable to process your credit card!"
    false
  end

  def update_with_payment params
    raise Stripe::InvalidRequestError.new('Stripe Card Token is blank!', 'stripe_card_token') if params[:stripe_card_token].blank?

    customer             = Stripe::Customer.retrieve stripe_customer_token
    customer.card        = params[:stripe_card_token]
    customer.description = self.id
    customer             = customer.save # wonky, blame stripe!

    card = customer.active_card

    self.stripe_customer_token = customer.id
    self.last_four             = card.last4
    self.card_type             = card.type
    self.next_bill_on          = Date.parse customer.next_recurring_charge.date
    self.card_expiration       = "#{card.exp_month}-#{card.exp_year}"

    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }"
    errors[:base] << "Unable to process your credit card!"
    false
  end

end

class Subscription < ActiveRecord::Base

  attr_accessor :stripe_card_token

  belongs_to :plan
  belongs_to :user

  validates :plan_id,               presence: true
  validates :user_id,               presence: true, uniqueness: true
  validates :stripe_customer_token, presence: true

  def save_with_payment
    customer = Stripe::Customer.create email: user.email, plan: plan.slug, card: stripe_card_token

    self.stripe_customer_token = customer.id
    self.next_bill_on          = Date.parse customer.next_recurring_charge.date

    set_card_info customer.active_card
    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }"
    errors[:base] << "Unable to process your credit card!"
    false
  end

  def update_with_payment params
    raise Stripe::InvalidRequestError.new('Stripe Card Token is blank!', 'stripe_card_token') if params[:stripe_card_token].blank?
    customer             = stripe_customer
    customer.card        = params[:stripe_card_token]
    customer.description = self.id
    customer             = customer.save # wonky, blame stripe!

    self.next_bill_on    = Date.parse customer.next_recurring_charge.date
    set_card_info customer.active_card

    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }"
    errors[:base] << "Unable to update your billing info!"
    false
  end

  def change_plan_to new_plan_id
    new_plan = Plan.find new_plan_id

    customer      = stripe_customer
    customer.plan = new_plan.slug
    customer      = customer.save

    self.plan         = new_plan
    self.next_bill_on = Date.parse customer.next_recurring_charge.date

    save
  rescue Stripe::InvalidRequestError => e
    logger.error "[STRIPE] #{ e }"
    errors[:base] << "Unable to change your plan!"
    false
  end

private

  def set_card_info new_card
    self.last_four       = new_card.last4
    self.card_type       = new_card.type
    self.card_expiration = "#{ new_card.exp_month }-#{ new_card.exp_year }"
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve stripe_customer_token
  end

end

class Webhook < ActiveRecord::Base

  belongs_to :user

  validates              :stripe_webhook_id,   presence: true, uniqueness: true
  validates              :stripe_webhook_type, presence: true
  validates              :object,              presence: true

  before_validation :set_user, :on => :create
  after_create      :send_notification

  def self.initialize_from_stripe attrs
    new stripe_webhook_id:   attrs['id'],
        livemode:            attrs['livemode'],
        stripe_webhook_type: attrs['type'],
        data:                attrs['data']
  end

  def self.create_from_stripe! attrs
    hook = initialize_from_stripe attrs
    hook.save!
    hook
  end

  def data= hash
    self.object = hash['object']
  end

  def stripe_customer_id
    return nil if object.blank?
    object['customer']
  end

private

  def set_user
    self.user ||= Subscription.where(stripe_customer_token: stripe_customer_id).first.try :user
  end

  def send_notification
    ActiveSupport::Notifications.instrument "stripe.#{ stripe_webhook_type }", { user_id: user_id, object: object }
  end

end

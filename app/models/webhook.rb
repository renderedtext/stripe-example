class Webhook < ActiveRecord::Base

  belongs_to :user

  validates :stripe_webhook_id,   presence: true, uniqueness: true
  validates :stripe_webhook_type, presence: true
  validates :object,              presence: true
  validates :livemode,            presence: true

  before_validation :set_user, :on => :create
  after_create      :send_notification

  def stripe_customer_id
    return nil if object.blank?
    object['customer']
  end

private

  def set_user
    self.user ||= Subscription.where(stripe_customer_token: stripe_customer_id).first.try :user
  end

  def send_notification
    ActiveSupport::Notifications.instrument "stripe.#{ stripe_event_type }", { user_id: user_id, object: object }
  end

end

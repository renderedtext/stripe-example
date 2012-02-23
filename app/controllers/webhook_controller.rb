class WebhookController < ApplicationController

  def index
    params.reject! { |k,v| k.to_s == 'stripe_webhook' }

    Webhook.create_from_stripe! params
    head :ok

  end

end

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  stripe_handler.setupForm('subscription')


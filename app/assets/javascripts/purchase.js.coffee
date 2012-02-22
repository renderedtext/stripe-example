jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  window.stripe_handler.setupForm('purchase')


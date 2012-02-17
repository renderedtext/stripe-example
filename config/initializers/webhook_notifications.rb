module ActiveSupport

  # see webhooks.md for more information on how to subscribe to webhook related notifications

  # For example, you can log all of the stripe webhooks
  # Notifications.subscribe /^stripe/ do |name, start, finish, id, payload|
  #   Rails.logger.debug [ '[STRIPE] webhook:', name, start, finish, id, payload ].join(' ')
  # end

end

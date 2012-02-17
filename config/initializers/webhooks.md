Stripe Webhooks
===============

Notifications
-------------

When an event is successfully recieved by the app, it will fire an ```ActiveSupport::Notification```, with the name in the format ```"stripe.#{ stripe_event_type }"```. The payload will contain the associated user_id if present, as well as the object that was provided by the webhook.

You can subscribe to the notification if you'd like to do something in response to a particular event.

  ```ruby
  # Flag a user account as past due if an invoice payment fails
  Notifications.subscribe 'stripe.invoice.payment_failed' do |name, start, finish, id, payload|
    User.where(id: payload[:user_id]).update_all past_due: true
  end
  ```


Events
------

This list of events was taken from the [events][events] page of the [Stripe][stripe] [api docs][api].

### Charges

  - **charge.succeeded**
    Occurs whenever a new charge is created and is successful.

  - **charge.failed**
    Occurs whenever a failed charge attempt occurs.

  - **charge.refunded**
    Occurs whenever a charge is refunded, including partial refunds.

  - **charge.disputed**
    Occurs whenever someone disputes a charge with their bank (chargeback).

### Customers

  - **customer.created**
    Occurs whenever a new customer is created.

  - **customer.updated**
    Occurs whenever any property of a customer changes.

  - **customer.deleted**
    Occurs whenever a customer is deleted.

  - **customer.subscription.created**
    Occurs whenever a customer with no subscription is signed up for a plan.

  - **customer.subscription.updated**
    Occurs whenever a subscription changes. Examples would include switching from one plan to another, or switching status from trial to active.

### Subscriptions

  - **customer.subscription.deleted**
    Occurs whenever a customer ends their subscription.

  - **customer.subscription.trial_will_end**
    Occurs three days before the trial period of a subscription is scheduled to end.

### Discounts

  - **customer.discount.created**
    Occurs whenever a coupon is attached to a customer.

  - **customer.discount.updated**
    Occurs whenever a customer is switched from one coupon to another.

  - **customer.discount.deleted**
    Occurs whenever a customer's discount is removed.

### Invoices

  - **invoice.created**
    Occurs whenever a new invoice is created.

    *Note* that if you are using webhooks, Stripe will wait until they have all succeeded to attempt to pay the invoice.

  - **invoice.updated**
    Occurs whenever an invoice changes (for example, the amount could change).

  - **invoice.payment_succeeded**
    Occurs whenever an invoice attempts to be paid, and the payment succeeds.

  - **invoice.payment_failed**
    Occurs whenever an invoice attempts to be paid, and the payment fails.

  - **invoiceitem.created**
    Occurs whenever an invoice item is created.

  - **invoiceitem.updated**
    Occurs whenever an invoice item is updated.

  - **invoiceitem.deleted**
    Occurs whenever an invoice item is deleted.

### Plans

  - **plan.created**
    Occurs whenever a plan is created.

  - **plan.updated**
    Occurs whenever a plan is updated.

  - **plan.deleted**
    Occurs whenever a plan is deleted.

### Coupons

  - **coupon.created**
    Occurs whenever a coupon is created.

  - **coupon.updated**
    Occurs whenever a coupon is updated.

  - **coupon.deleted**
    Occurs whenever a coupon is deleted.

### Transfers

  - **transfer.created**
    Occurs whenever a new transfer is created.

  - **transfer.failed**
    Occurs whenever Stripe attempts to send a transfer and that transfer fails.

### Misc

  - **ping**
    May be sent by Stripe at any time to see if a provided webhook URL is working.

See also
--------

  - [Webhooks][webhooks] specific docs
  - Your stripe webhooks [settings][settings]
  - Railscast [Episode #249][railscast] on rails notifications

<!-- Links -->

[api]:       https://stripe.com/docs/api                 "Stripe API"
[events]:    https://stripe.com/docs/api#event_types     "Stripe Webhook Events"
[railscast]: http://railscasts.com/episodes/249          "Railscast episode #249 Notifications in Rails 3"
[settings]:  https://manage.stripe.com/#account/webhooks "Stripe Webhook Settings"
[stripe]:    https://stripe.com/                         "Stripe"
[webhooks]:  https://stripe.com/docs/webhooks            "Stripe Webhook Docs"

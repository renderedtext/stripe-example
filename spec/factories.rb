FactoryGirl.define do

  factory :user, aliases: [:owner] do
    sequence(:email)      { |n| "user_#{ n }@example.com" }
    password              'password'
    password_confirmation { password }
  end

  factory :plan do
    sequence(:name) { |n| "Plan #{ n }" }
    sequence(:price){ |n| (n - 1) * 2.25 }
  end

  factory :subscription do
    user
    plan
    sequence(:stripe_customer_token) { |n| "Token #{ n }" }
  end

  factory :item do
    sequence(:name)  { |n| "Item #{ n }" }
    sequence(:price) { |n| (n) * 2.25 }
  end

end

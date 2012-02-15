require 'spec_helper'

describe Subscription do

  let(:plan) { Plan.first    }
  let(:user) { Factory :user }

  it 'requires a unique user' do
    another_user = Factory :user

    Factory.build( :subscription, user:          nil).should_not be_valid
    Factory.create(:subscription, user:         user).should     be_valid
    Factory.build( :subscription, user:         user).should_not be_valid
    Factory.create(:subscription, user: another_user).should     be_valid
  end

  it 'requires a plan' do
    Factory.build( :subscription, plan:  nil).should_not be_valid
    Factory.create(:subscription, plan: plan).should     be_valid
  end

  it 'requires a stripe customer token' do
    Factory.build(:subscription, plan: plan, stripe_customer_token: nil).should_not be_valid
    Factory.build(:subscription, plan: plan, stripe_customer_token: '1').should     be_valid
  end

  describe 'credit card info' do

    use_vcr_cassette 'billing/customer_create', :record => :new_episodes

    before do
      card = { number: '4242424242424242', exp_month: '11', exp_year: '2012' }

      @subscription = Factory.create :subscription, user: user, plan: plan, stripe_card_token: card
      @subscription.save_with_payment

      @customer    = Stripe::Customer.retrieve @subscription.stripe_customer_token
      @active_card = @customer.active_card
    end

    subject { @subscription }

    its(:card_expiration) { should == "#{ @active_card.exp_month }-#{ @active_card.exp_year }" }
    its(:card_type)       { should == @active_card.type  }
    its(:last_four)       { should == @active_card.last4 }
    its(:next_bill_on)    { should == Date.parse(@customer.next_recurring_charge.date) }

  end

end

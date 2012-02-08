require 'spec_helper'

describe Subscription do

  let(:plan) { Plan.first    }
  let(:user) { Factory :user }

  it 'requires a unique user' do
    user_a = Factory :user
    user_b = Factory :user

    Factory.build( :subscription, user:    nil).should_not be_valid
    Factory.create(:subscription, user: user_a).should     be_valid
    Factory.build( :subscription, user: user_a).should_not be_valid
    Factory.create(:subscription, user: user_b).should     be_valid
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

    use_vcr_cassette 'billing/customer_create', :record => :all

    let(:plan) { Plan.first }
    let(:card) {{ number: '4242424242424242', exp_month: '11', exp_year: '2012' }}

    before do
      @subscription = user.build_subscription plan: plan, stripe_card_token: card
      @subscription.save_with_payment
    end

    describe '#last_four' do

      it 'returns the last 4 digits of the associated credit card number' do
        @subscription.last_four.should == '4242'
      end

    end

    describe '#card_type' do

      it 'returns the card type of the associated credit card' do
        @subscription.card_type.should == 'Visa'
      end

    end

    describe '#next_bill_on' do

      it 'returns the date of the next charge' do
        @subscription.next_bill_on.should == Date.parse('2012-03-08')
      end

    end

    describe '#card_expiration' do

      it 'returns the date of the next charge' do
        @subscription.card_expiration.should == '11-2012'
      end

    end

  end

end

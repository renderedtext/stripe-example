require 'spec_helper'

describe Webhook do

  its(:livemode)            { should validate :inclusion  }
  its(:object)              { should validate :presence   }
  its(:stripe_webhook_id)   { should validate :presence   }
  its(:stripe_webhook_id)   { should validate :uniqueness }
  its(:stripe_webhook_type) { should validate :presence   }

  describe '#stripe_customer_id' do

    context 'object["customer"] is nil' do

      subject { Webhook.new }
      its(:stripe_customer_id) { should be_nil }

    end

    context 'object["customer"] is not nil' do

      subject { Webhook.new object: { 'customer' => 'foo' }}
      its(:stripe_customer_id) { should == 'foo' }

    end

  end

  describe 'user' do

    before do
      @subscription = Factory :subscription
      @user = @subscription.user
    end

    context '#stripe_customer_id is not present' do

      subject    { Webhook.create  }
      its(:user) { should be_blank }

    end

    context '#stripe_customer_id is not a valid user' do

      subject    { Webhook.create object: { 'customer' => 'moocows123' }}
      its(:user) { should be_blank }

    end

    context '#stripe_customer_id is represents a valid user' do

      subject { Webhook.create object: { 'customer' => @subscription.stripe_customer_token }}

      it 'associates the user' do
        subject.user.should == @user
      end

    end

  end

end

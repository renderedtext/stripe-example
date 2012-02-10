require 'spec_helper'

describe 'Subscriptions' do

  let(:plan) { Plan.first      }
  let(:user) { Factory :user   }
  let(:card) { valid_card_data }

  subject { page }

  before do
    login_as user
  end

  describe 'signing up' do

    before do
      visit plans_path
    end

    before do
      click_link plan.name
    end

    context 'with invalid data' do

      use_vcr_cassette 'stripe/subscription-failure', :record => :none

      it 'displays error messages' do
        # invalid data
        click_button "Signup for the #{ plan.name } plan"

        should have_content('Unable to add subscription!')
        should have_content('Something went wrong')
      end

    end

    context 'with simulated valid data' do

      use_vcr_cassette 'stripe/subscription-success', :record => :none

      before do
        # create a Stripe::Customer manually so that we know what will be returned when
        # Stripe::Customer#create is called by Subscription#save_with_payment
        customer = Stripe::Customer.create card: card, plan: plan
        Stripe::Customer.stub!(:create).and_return(customer)

        # These fields don't actually get passed to Stripe::Customer#create,
        # because we're using stub!, however we need to make sure they are on the form.
        fill_in_fields card_number: card[:number],
                       card_code:   card[:cvc],
                       card_zip:    card[:address_zip]

        select card[:exp_month].to_s.gsub(/^0/, ''), from: 'card_month' # garh
        select card[:exp_year].to_s,                 from: 'card_year'

        click_button "Signup for the #{ plan.name } plan"
      end

      it 'creates subscription for user' do
        user.subscription.should be_present
      end

      it 'redirects to dashboard' do
        should_be_on root_path
        should have_content('Subscription added!')
      end

    end

    it 'is linked from the root path' do
      visit root_path
      page.should have_css("a[href='#{ plans_path }']")
    end

  end

  describe 'updating billing info' do

    context 'with invalid data' do

      use_vcr_cassette 'stripe/billing-update-failure', :record => :none

      before do
        @subscription = user.build_subscription plan: plan, stripe_card_token: card
        @subscription.save_with_payment

        visit edit_subscription_path(@subscription)
      end

      it 'displays error messages' do
        # invalid data
        click_button 'Update' # won't set the stripe_card_token

        should have_content('Unable to update billing!')
        should have_content('Something went wrong')
      end

    end

    context 'with simulated svalid data' do

      use_vcr_cassette 'stripe/billing-update-success', :record => :none

      before do
        @subscription = user.build_subscription plan: plan, stripe_card_token: card
        @subscription.save_with_payment

        visit edit_subscription_path(@subscription)
      end

      it 'updates the data successfully' do
        # create a Stripe::Customer manually so that we know what will be returned when
        # Stripe::Customer#create is called by Subscription#save_with_payment
        customer = Stripe::Customer.create card: card, plan: plan
        Stripe::Customer.stub!(:create).and_return(customer)

        # These fields don't actually get passed to Stripe::Customer#create,
        # because we're using stub!, however we need to make sure they are on the form.
        fill_in_fields card_number: '4111111111111111',
                       card_code:   '789',
                       card_zip:    '19877'

        select card[:exp_month].to_s.gsub(/^0/, ''), from: 'card_month' # garh
        select card[:exp_year].to_s,                 from: 'card_year'

        click_button 'Update'
      end

    end

  end

  describe 'change plan' do

    let(:other_plan) { Plan.last }

    use_vcr_cassette 'stripe/billing-plan-change', :record => :all

    before do
      @subscription = user.build_subscription plan: plan, stripe_card_token: card
      @subscription.save_with_payment

      visit edit_subscription_path(@subscription)
    end

    it 'switches plans' do
      click_link "Switch to the #{ other_plan.name } plan"
      user.reload.plan.should == other_plan
      should have_content("The plans. You have changed them.")
    end

  end

end

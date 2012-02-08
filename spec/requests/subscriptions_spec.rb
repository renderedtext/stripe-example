require 'spec_helper'

describe 'Subscriptions' do

  let(:plan) { Plan.first    }
  let(:user) { Factory :user }

  subject { page }

  before do
    login_as user
    visit plans_path
  end

  describe 'signing up' do

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

      let(:card) { valid_card_data }

      use_vcr_cassette 'stripe/subscription-success', :record => :none

      before do
        # create a Stripe::Customer manually so that we know what will be returned when
        # Stripe::Customer#create is called by Subscription#save_with_payment
        customer = Stripe::Customer.create card: card, plan: 'small'
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

end

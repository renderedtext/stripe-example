require 'spec_helper.rb'

describe 'Cancelling accounts' do

  use_vcr_cassette 'stripe/cancelling-account'

  let(:plan) { Plan.first      } 
  let(:user) { Factory :user   } 
  let(:card) { valid_card_data } 

  before do
    @subscription = user.build_subscription plan:              plan,
                                           stripe_card_token: card
    @subscription.save_with_payment

    login_as user
    visit edit_subscription_path @subscription
  end

  it 'Should provide a link to cancel accounances' do
    page.should have_content "cancel account"
  end

  it 'Should remove the subscription when you cancel the account' do
    click_link "cancel account"

    user.reload.subscription.should == nil
  end

  it 'Should notify the user that the account has been cancelled' do
    click_link "cancel account"

    page.should have_content "account cancelled. :("
  end

end

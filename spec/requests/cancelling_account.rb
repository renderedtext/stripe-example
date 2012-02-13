require 'spec_helper.rb'

describe 'Cancelling accounts' do

  let(:plan)         { Plan.first    }
  let(:user)         { Factory :user }
  let(:subscription) { Factory :subscription, :user => @user,
                                              :plan => @plan  }
  
  before do
    visit edit_subscription_page @subscription
  end

  it 'Should provide a link to cancel accounts' do
    page.should have_content "cancel account"
  end

  it 'Should remove the subscription when you cancel the account' do
    click_link "cancel account"

    @user.subscription.should != @subscription
  end

  it 'Should notify the user that the account has been cancelled' do
    page.should have_content "account cancelled. :("
  end

end

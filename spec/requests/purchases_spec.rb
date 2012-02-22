require 'spec_helper.rb'

describe 'A la carte purchases' do

  let (:user) { Factory :user }

  before do
    login_as user
  end

  it 'should have a link to the purchases page on the index' do
    visit root_path

    click_link "purchases"

    page.should_be_on_path purchases_path
  end

  it 'should list the purchases on the purchases page' do
    visit purchases_path

    Purchase.all.each do |purchase|
      page.should have_content purchase.name
    end

  end

  it 'should allow the user to purchase items' do
    purchase = Purchase.last

    visit purchases_path

    click_link purchase.name

    user.should have(1).purchase
  end

end

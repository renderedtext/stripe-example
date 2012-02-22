require 'spec_helper.rb'

describe 'A la carte purchases' do

  use_vcr_cassette 'stripe/ala-carte-purchases', record: :all

  let (:user) { Factory        :user }

  before do
    @item = Factory.create :item, :price => "100.00"
    login_as user
  end

  it 'should have a link to the purchases page on the index' do
    visit root_path

    click_link "purchases"

    should_be_on purchases_path
  end

  it 'should list the purchases on the purchases page' do
    visit purchases_path

    Purchase.all.each do |purchase|
      page.should have_content purchase.name
    end

  end

  it 'should take user to a page to enter credit card info when they click an item', :js => true do
    visit purchases_path

    click_link @item.name

    page.should have_content "Credit Card Number"
    page.should have_css "input[ type='submit']"
  end

  it 'should allow users to purchase items' do
    visit new_purchase_path(:item_id => @item.id)

    # create a Stripe::Charge manually so that we know what will be returned when
    # Stripe::Charge#create is called by Purchase#save_with_payment
    card   = valid_card_data
    charge = Stripe::Charge.create amount:      (@item.price * 100).to_i,
                                   card:        card,
                                   currency:    'usd',
                                   description: "#{ user.email } purchased #{ @item.name }"
    Stripe::Charge.stub!(:create).and_return(charge)

    # These fields don't actually get passed to Stripe::Customer#create,
    # because we're using stub!, however we need to make sure they are on the form.
    fill_in_fields card_number: card[:number],
                   card_code:   card[:cvc],
                   card_zip:    card[:address_zip]

    select card[:exp_month].to_s.gsub(/^0/, ''), from: 'card_month' # garh
    select card[:exp_year].to_s,                 from: 'card_year'

    click_button @item.name

    page.should_not have_content "Unable to process"
    page.should     have_content "Thanks for purchasing"

    user.reload.should have(1).purchase
  end

end

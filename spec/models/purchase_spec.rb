require 'spec_helper'

describe Purchase do
  use_vcr_cassette 'model/purchase', record: :all

  let(:user)         { Factory :user                 }
  let(:item)         { Factory :item, price: "10.00" }

  before do
    card   = valid_card_data
    charge = Stripe::Charge.create amount:      (item.price * 100).to_i,
                                   card:        card,
                                   currency:    'usd',
                                   description: "#{ user.email } purchased #{ item.name }"
    Stripe::Charge.stub!(:create).and_return(charge)
  end

  it 'should require a price' do
    p = user.purchases.new(item: item)
    p.save_with_payment
    p.should be_valid

    p = user.purchases.new(item: item)
    p.save_with_payment
    p.price = nil
    p.should_not be_valid
  end

  it 'should require an item' do
    p = user.purchases.new
    p.save_with_payment
    p.should_not be_valid
  end

  it 'should require a user' do
    p = Purchase.new(item: item)
    p.save_with_payment
    p.should_not be_valid

    p = Purchase.new(item: item, user: user)
    p.save_with_payment
    p.should be_valid
  end

end

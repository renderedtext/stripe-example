require 'spec_helper'

describe Item do

  it 'requires a price' do
    Factory.build(:item, price: nil     ).should_not be_valid
    Factory.build(:item, price: "bacon" ).should_not be_valid
    Factory.build(:item, price: "100.00").should     be_valid
    Factory.build(:item                 ).should     be_valid
  end

end

require 'spec_helper'

describe Plan do

  it 'requires a unique name' do
    Factory.build( :plan, name:      nil).should_not be_valid
    Factory.create(:plan, name: 'Plan A').should     be_valid
    Factory.build( :plan, name: 'Plan A').should_not be_valid
    Factory.create(:plan, name: 'Plan B').should     be_valid
  end

  it 'requires a numeric price greater than or equal to 0.00' do
    Factory.build(:plan, price:   nil).should_not be_valid
    Factory.build(:plan, price: -1.00).should_not be_valid
    Factory.build(:plan, price:  0.00).should     be_valid
    Factory.build(:plan, price:  1.00).should     be_valid
  end

  describe '#to_param' do

    it 'returns #slug' do
      plan = Factory.create :plan
      plan.to_param.should == plan.slug
    end

  end

end

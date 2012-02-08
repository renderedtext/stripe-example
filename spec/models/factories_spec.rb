require 'spec_helper'

describe 'Factories' do

  FactoryGirl.factories.map(&:name).sort.each do |factory_name|
    it "Factory #{ factory_name.inspect } should generate properly" do
      3.times { Factory(factory_name).should be_valid }
    end
  end

end

require 'spec_helper'

describe Item do

  its (:price) { should validate :numericality, {greater_than_or_equal_to: 0 }}

end

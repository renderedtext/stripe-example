require 'spec_helper'

describe Purchase do

  its(:price) { should validate :presence }
  its(:item)  { should validate :presence }
  its(:user)  { should validate :presence }

end

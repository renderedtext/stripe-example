class Item < ActiveRecord::Base
  has_many :purchases
  has_many :users, through: :purchases

  validates_numericality_of :price, :greater_than_or_equal_to => 0.01
end

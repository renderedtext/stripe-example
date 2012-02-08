class Plan < ActiveRecord::Base

  extend FriendlyId

  friendly_id :name, :use => :slugged

  has_many :subscriptions

  validates :name,  presence: true, uniqueness: true
  validates :slug,  presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

end

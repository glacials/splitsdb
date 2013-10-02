class Game < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :categories
  validates_presence_of :name
end

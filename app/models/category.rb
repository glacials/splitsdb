class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs
  validates_presence_of :game
  validates_presence_of :name
end

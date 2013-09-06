class Game < ActiveRecord::Base
  has_many :divisions
  has_many :categories, :through => :divisions
end

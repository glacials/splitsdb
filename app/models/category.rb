class Category < ActiveRecord::Base
  has_many :divisions
  has_many :games, :through => :divisions
end

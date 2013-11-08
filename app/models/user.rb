class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_authentic
  has_many :authentications
  has_many :runs
  has_many :games, through: :runs, :uniq => true
  has_many :categories, through: :runs, :uniq => true
  validates_presence_of :email, :password, :name, on: :create
end

class Run < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :splits
  has_one :game, :through => :category
  validates_presence_of :user, :time

  def time(format = "%-k:%M:%S")
    Time.at(self.read_attribute(:time)).utc.strftime(format)
  end
  def time_seconds()
    self.read_attribute(:time)
  end
end

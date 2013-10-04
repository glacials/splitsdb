class Split < ActiveRecord::Base
  belongs_to :run
  def best_run(format = "%-k:%M:%S")
    Time.at(self.best_run_seconds).utc.strftime(format)
  end
  def best_run_seconds()
    self.read_attribute(:best_run)
  end
  def best_segment(format = "%-k:%M:%S")
    Time.at(self.best_segment_seconds).utc.strftime(format)
  end
  def best_segment_seconds()
    self.read_attribute(:best_segment)
  end
end

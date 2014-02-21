class DelayedJob < ActiveRecord:Base
  self.table_name = "delayed_jobs"
  attr_accessible :multimedia_id, :job_progress
  belongs_to :multimedia
end
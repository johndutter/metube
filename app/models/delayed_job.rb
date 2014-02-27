class DelayedJob < ActiveRecord::Base
  self.table_name = "delayed_jobs"
  belongs_to :multimedia
end
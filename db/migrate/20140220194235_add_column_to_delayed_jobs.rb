class AddColumnToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :multimedia_id, :integer
    add_column :delayed_jobs, :job_progress, :integer, :default => 0
  end
end

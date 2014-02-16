Delayed::Worker.destroy_failed_jobs = false
#how often worker checks db for jobs
Delayed::Worker.sleep_delay = 2
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 30.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'videos'
Delayed::Worker.delay_jobs = true
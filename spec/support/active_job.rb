RSpec.configure do |config|
  ActiveJob::Base.queue_adapter = :inline

  config.around(:each, test_jobs_queue: true) do |example|
    original_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    example.run
    ActiveJob::Base.queue_adapter = original_queue_adapter
  end
end

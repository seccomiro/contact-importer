class EmailCheckerWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    EmailChecker.new(import).execute
  end
end

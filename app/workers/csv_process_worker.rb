class CsvProcessWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    CsvImporter.new(import).execute
    EmailCheckerWorker.perform_async(import.id)
  end
end

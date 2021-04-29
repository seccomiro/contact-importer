class CsvProcessWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    CsvImporter.new(import).execute
  end
end

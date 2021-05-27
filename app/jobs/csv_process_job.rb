class CsvProcessJob < ApplicationJob
  queue_as :default

  def perform(import)
    CsvImporter.new(import).execute
    EmailCheckerJob.perform_later(import)
  end
end

class EmailCheckerJob < ApplicationJob
  queue_as :default

  def perform(import)
    EmailChecker.new(import).execute
  end
end

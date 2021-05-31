class UserNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
  end

  def self.notify_import_finished(import)
    filename = Rails.application.routes.url_helpers.rails_blob_path(import.file).split('/').last
    action = Rails.application.routes.url_helpers.import_path(import)
    broadcast_to(
      import.user, {
        message: "The file \"#{filename}\" has finished processing.",
        import_id: import.id,
        action: action
      }
    )
  end
end

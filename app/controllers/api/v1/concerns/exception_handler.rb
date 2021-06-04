module Api::V1::Concerns::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_fail_response('Record not found', :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_fail_response(error_data(e), :unprocessable_entity)
    end

    # TODO: Check how to rescue from a 400 Bad Request
    # rescue_from ActionController::BadRequest do |e|
    #   json_error_response(e.message, :bad_request)
    # end
  end

  private

  def error_data(error)
    error.respond_to?(:record) ? error.record.errors.messages : error.message
  end
end

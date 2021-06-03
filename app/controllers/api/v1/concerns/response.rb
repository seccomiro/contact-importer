module Api::V1::Concerns::Response
  def json_fail_response(data = nil, status = :bad_request)
    @data = data
    render 'api/v1/errors/fail', status: status
  end

  def json_error_response(message = nil, status = :bad_request)
    @message = message
    render 'api/v1/errors/error', status: status
  end
end

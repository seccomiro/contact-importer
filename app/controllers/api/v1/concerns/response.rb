module Api::V1::Concerns::Response
  def json_fail_response(data = nil, status = :bad_request)
    @data = data
    render 'api/v1/fail', status: status
  end
end

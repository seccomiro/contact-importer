class Api::V1::ApiController < ActionController::API
  include Api::V1::Concerns::Response
  include Api::V1::Concerns::ExceptionHandler

  before_action :authenticate_user!
end

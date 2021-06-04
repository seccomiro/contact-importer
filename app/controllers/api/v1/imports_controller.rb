class Api::V1::ImportsController < Api::V1::ApiController
  def index
    @imports = current_user.imports
  end
end

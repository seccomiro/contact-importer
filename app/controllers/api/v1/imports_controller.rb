class Api::V1::ImportsController < Api::V1::ApiController
  before_action :set_import, only: [:show]

  def index
    @imports = current_user.imports
  end

  def show
  end

  private

  def set_import
    @import = current_user.imports.find(params[:id])
  end
end

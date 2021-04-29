class ImportsController < ApplicationController
  before_action :set_import, only: [:show]
  before_action :authenticate_user!

  def index
    @imports = Import.all
  end

  def show
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
    @import.user = current_user

    if @import.save
      redirect_to @import, notice: 'Import was successfully created.'
    else
      render :new
    end
  end

  def assign
  end

  def process
  end

  private

  def set_import
    @import = Import.find(params[:id])
  end

  def import_params
    params.require(:import).permit(:file)
  end
end

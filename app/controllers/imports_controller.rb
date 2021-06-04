class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :assign, :execute]
  before_action :authenticate_user!

  def index
    @imports = current_user.imports
  end

  def show
    @importable_attributes = ImportContact.importable_attributes
  end

  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.create(import_params)

    if @import.save
      redirect_to @import, notice: 'Import was successfully created.'
    else
      render :new
    end
  end

  def assign
    @import.headers = header_params
    @import.save
    redirect_to @import
  end

  def execute
    @import.status = :processing
    @import.save

    CsvProcessJob.perform_later(@import)

    redirect_to @import
  end

  private

  def set_import
    @import = current_user.imports.find(params[:id])
  end

  def import_params
    params.require(:import).permit(:file)
  end

  def header_params
    params.require(:file_header).permit!.to_hash
  end
end

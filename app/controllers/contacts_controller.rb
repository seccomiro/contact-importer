class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = Contact.includes(:credit_card).paginate(page: params[:page], per_page: 5)
  end
end

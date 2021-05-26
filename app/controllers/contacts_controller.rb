class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts.includes(:credit_card)
                            .paginate(page: params[:page], per_page: params[:per_page] || 5)
  end
end

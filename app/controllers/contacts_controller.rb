class ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:credit_card).all
  end
end

class Api::V1::ContactsController < Api::V1::ApiController
  def index
    @contacts = current_user.contacts
  end
end

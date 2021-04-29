class Contact < ApplicationRecord
  belongs_to :user
  has_one :credit_card, dependent: :destroy
end

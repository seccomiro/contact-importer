class Contact < ApplicationRecord
  belongs_to :user
  has_one :credit_card, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :user, presence: true
end

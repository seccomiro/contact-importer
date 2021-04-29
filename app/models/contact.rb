class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :credit_card
end

class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card, optional: true, dependent: :destroy

  validates :name, presence: true, format: { with: /[-\w\s]/i }
  validates :email, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true, format: {
    with: /\(\+[0-9]{2}\) [0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2} [0-9]{2}|\(\+[0-9]{2}\) [0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}/
  }
  validates :address, presence: true
  validates :user, presence: true
  validates :email, uniqueness: { scope: :user_id }

  accepts_nested_attributes_for :credit_card
end

class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card, optional: true, dependent: :destroy

  validates :name, presence: true, format: { with: /\A[a-zA-Z\-\ ]*\z/ }
  validates :email, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true, format: {
    with: /\(\+[0-9]{2}\) [0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}|\(\+[0-9]{2}\) [0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}/
  }
  validates :address, presence: true
  validates :user, presence: true
  validates :email, uniqueness: { scope: :user_id }
  # validate :birthdates

  accepts_nested_attributes_for :credit_card

  # private

  # TODO: Validation logic should be moved to ImportContact
  # def birthdates
  #   valid_formats = ['%F', '%Y%m%d']
  #   return if valid_formats.any? { |f| DateTime.strptime(birthdate, f) rescue false }

  #   errors.add(:birthdate, 'is at an invalid format')
  # end
end

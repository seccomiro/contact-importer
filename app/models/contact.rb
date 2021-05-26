class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card, optional: true, dependent: :destroy

  validates :name, presence: true, format: { with: /\A[a-zA-Z\-\ ]*\z/ }
  validates :email, presence: true, uniqueness: { scope: :user_id }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :birthdate, presence: true
  validates :phone, presence: true, format: {
    with: /\(\+[0-9]{2}\) [0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}|\(\+[0-9]{2}\) [0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}/
  }
  validates :address, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :credit_card

  def email_check
    EmailCheck.find_by(email: email)
  end
end

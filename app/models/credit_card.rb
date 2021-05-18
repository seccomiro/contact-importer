class CreditCard < ApplicationRecord
  include CreditCardValidable

  validates :contact, presence: true
  validates :number, presence: true
  validates :franchise, presence: true

  has_one :contact, dependent: :restrict_with_exception
end

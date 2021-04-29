class CreditCard < ApplicationRecord
  include CreditCardValidable

  validates :contact, presence: true
  validates :number, presence: true
  validates :franchise, presence: true

  belongs_to :contact
end

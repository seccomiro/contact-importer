module CreditCardValidable
  extend ActiveSupport::Concern

  included do
    before_validation :fetch_franchise
    before_create :mask_number
  end

  private

  def fetch_franchise
    self.franchise = CreditCardValidation.new(number).fetch_issuer_name
  rescue StandardError => e
    errors.add(:credit_card_number, "has #{e.message}")
  end

  def mask_number
    new_number = ('*' * (number.size - 4)) + CreditCardValidation.new(number).last_digits
    self.token = CreditCardValidation.new(number).encrypt
    self.number = new_number
  end
end

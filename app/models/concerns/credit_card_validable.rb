module CreditCardValidable
  extend ActiveSupport::Concern

  included do
    before_validation :fetch_franchise
  end

  private

  def fetch_franchise
    self.franchise = CreditCardValidation.new(number).fetch_issuer_name
  rescue StandardError => e
    errors.add(:credit_card_number, "has #{e.message}")
  end
end

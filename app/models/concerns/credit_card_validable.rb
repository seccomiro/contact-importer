module CreditCardValidable
  extend ActiveSupport::Concern

  included do
    before_validation :fetch_franchise
  end

  private

  def fetch_franchise
    self.franchise = CreditCardValidation.new(number).fetch_issuer_name
  end
end

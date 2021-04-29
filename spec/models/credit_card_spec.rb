require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { create(:credit_card) }

  it 'has the correct franchise before validation' do
    expect(credit_card.franchise).to eq(CreditCardValidation.new(credit_card.number).fetch_issuer_name)
  end
end

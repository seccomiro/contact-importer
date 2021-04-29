require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:number) { '4111111111111111' }
  let(:credit_card) { create(:credit_card, number: number) }

  it 'has the correct franchise before validation' do
    expect(credit_card.franchise).to eq(CreditCardValidation.new(number).fetch_issuer_name)
  end
end

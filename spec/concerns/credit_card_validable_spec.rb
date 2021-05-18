require 'rails_helper'

shared_examples_for 'CreditCardValidable' do
  describe 'before_validation' do
    let(:model) { build(described_class.to_s.underscore.to_sym) }

    it 'has the correct franchise' do
      model.valid?
      expect(model.franchise).to eq(CreditCardValidation.new(model.number).fetch_issuer_name)
    end
  end

  describe 'before_create' do
    context 'with a valid credit card number' do
      let(:model) { build(described_class.to_s.underscore.to_sym) }

      before do
        @original_number = model.number
        model.save
      end

      it 'have masked the credit card number' do
        expect(model.number).to eq(('*' * (@original_number.size - 4)) + @original_number[-4..])
      end

      it 'have defined a valid token' do
        expect(model.token).to eq(CreditCardValidation.new(@original_number).encrypt)
      end
    end
  end
end

require 'rails_helper'

describe CreditCardValidation do
  let(:valid_credit_cards) do
    [
      { issuer: 'American Express', number: '341111111111111' },
      { issuer: 'Bankcard', number: '5602221111111111' },
      { issuer: 'UkrCard', number: '6042009911111111' },
      { issuer: 'UkrCard', number: '6042009911111111222' },
      { issuer: 'MIR', number: '2200111111111111' },
      { issuer: 'Switch', number: '5641821111111111' },
      { issuer: 'Switch', number: '564182111111111122' },
      { issuer: 'Switch', number: '5641821111111111223' }
    ]
  end
  let(:formatted_credit_cards) do
    [
      { issuer: 'Bankcard', number: '5602 2211 1111 1111' },
      { issuer: 'Bankcard', number: '5602-2211-1111-1111' },
      { issuer: 'Bankcard', number: '5602.2211.1111.1111' }
    ]
  end
  let(:nonexisting_issuer) { '0000000000000000' }
  let(:invalid_length_cards) do
    [
      { issuer: 'Switch', number: '564182111111111' },
      { issuer: 'Discover Card', number: '644111111111111' }
    ]
  end
  let(:invalid_min_max_length_cards) do
    [
      { issuer: 'UkrCard', number: '60400100' },
      { issuer: 'UkrCard', number: '4' },
      { issuer: 'UkrCard', number: '' },
      { issuer: 'Discover Card', number: '64411111111111111111' },
      { issuer: 'Diners Club United States & Canada', number: '54111111111111111111' }
    ]
  end

  describe '#fetch_issuer_name' do
    context 'with existing issuer' do
      it 'returns the correct issuer for a card' do
        valid_credit_cards.each do |credit_card|
          expect(described_class.new(credit_card[:number]).fetch_issuer_name).to eq(credit_card[:issuer])
        end
      end
    end

    context 'with formatted credit card number' do
      it 'returns the correct issuer for a card' do
        formatted_credit_cards.each do |credit_card|
          expect(described_class.new(credit_card[:number]).fetch_issuer_name).to eq(credit_card[:issuer])
        end
      end
    end

    context 'with nonexisting issuer' do
      it 'raises an "Nonexisting issuer" error' do
        expect { described_class.new(nonexisting_issuer).fetch_issuer_name }.to raise_error('Nonexisting issuer')
      end
    end
  end

  describe '#encrypt' do
    context 'with valid credit card' do
      it 'returns the correct hash for a credit card' do
        valid_credit_cards.each do |credit_card|
          expect(described_class.new(credit_card[:number]).encrypt).to eq(Digest::SHA1.hexdigest(credit_card[:number]))
        end
      end
    end

    context 'with a credit card with invalid length' do
      it 'raises an "Invalid credit card length" error' do
        invalid_length_cards.each do |credit_card|
          expect { described_class.new(credit_card[:number]).encrypt }.to raise_error('Invalid credit card length')
        end
      end
    end
  end

  describe '#check_min_max_length' do
    it 'raises an "Invalid credit card length" error' do
      invalid_min_max_length_cards.each do |credit_card|
        expect { described_class.new(credit_card[:number]).encrypt }.to raise_error('Invalid credit card length')
      end
    end
  end

  describe '#last_digits' do
    it 'returns the last 4 digits of the card number' do
      last_digits = described_class.new(valid_credit_cards.first[:number]).last_digits
      expect(last_digits).to eq(last_digits.last(4))
      expect(last_digits.size).to eq(4)
    end
  end
end

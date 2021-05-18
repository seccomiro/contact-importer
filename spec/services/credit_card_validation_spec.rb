require 'rails_helper'

describe CreditCardValidation do
  let(:valid_credit_cards) { build(:credit_card_data, :valid).credit_cards }
  let(:formatted_credit_cards) { build(:credit_card_data, :formatted).credit_cards }
  let(:nonexisting_issuer) { build(:credit_card_data, :nonexisting_issuer).credit_cards }
  let(:invalid_length_cards) { build(:credit_card_data, :invalid_length_cards).credit_cards }
  let(:invalid_min_max_length_cards) { build(:credit_card_data, :invalid_min_max_length_cards).credit_cards }

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
    let(:last_digits) { described_class.new(valid_credit_cards.first[:number]).last_digits }

    it 'returns 4 digits' do
      expect(last_digits.size).to eq(4)
    end

    it 'returns the last 4 digits of the card number' do
      expect(last_digits).to eq(last_digits.last(4))
    end
  end
end

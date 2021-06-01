require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it { is_expected.to have_attribute(:email) }
    it { is_expected.to respond_to(:password) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:contacts) }
    it { is_expected.to have_many(:imports) }
    it { is_expected.to have_many(:import_contacts).through(:imports) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#token' do
    subject(:user) { build(:user) }

    include_context 'with JWT context'

    context 'with an id' do
      it 'returns a valid JWT token for the user' do
        user.id = fixed_user_id

        expect(user.token).to eq(jwt)
      end
    end

    context 'without an id' do
      it 'raises "The user must be persisted in order to generate a JWT token"' do
        expect { user.token }.to raise_error('The user must be persisted in order to generate a JWT token')
      end
    end
  end

  describe '.from_token' do
    include_context 'with JWT context'

    context 'with a valid JWT token' do
      subject!(:user) { create(:user, id: fixed_user_id) }

      it 'returns the user for the token' do
        expect(described_class.from_token(jwt)).to eq(user)
      end
    end

    context 'with an invalid JWT token' do
      let(:invalid_token) { 'xxx' }

      it 'raises JWT::DecodeError' do
        expect { described_class.from_token(invalid_token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'with a valid JWT token that is not related to any user' do
      let(:token_without_user) { 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OTk5LCJleHAiOjE2MjM3ODI2OTR9.O0YBIa-j-RTYMK3b8nV-EZZt7mB-99JTetPywPVObls' }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { described_class.from_token(token_without_user) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a valid JWT token that does not have the correct payload' do
      let(:token_with_invalid_payload) { 'eyJhbGciOiJIUzI1NiJ9.eyJ0ZXN0IjoxMjMsImV4cCI6MTYyMzc4MjQ1NX0.H7ITDHksK1sqyJhfo6PRA5sRE1dNCR1NzRJsp0cxhnk' }

      it 'raises Jwt::InvalidPayload' do
        expect { described_class.from_token(token_with_invalid_payload) }.to raise_error(Jwt::InvalidPayload)
      end
    end
  end
end

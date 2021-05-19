require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject { build(:contact) }

  describe 'attributes' do
    it { is_expected.to have_attribute(:name) }
    it { is_expected.to have_attribute(:email) }
    it { is_expected.to have_attribute(:birthdate) }
    it { is_expected.to have_attribute(:phone) }
    it { is_expected.to have_attribute(:address) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:birthdate).of_type(:date) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:address).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:credit_card_id).of_type(:integer) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index([:user_id, :email]).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:credit_card).optional.dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:user_id) }
  end

  describe 'name validation' do
    context 'with a valid name' do
      it 'does not generate an validation error' do
        contact = build(:contact)
        contact.valid?

        expect(contact.errors[:name]).to be_empty
      end
    end

    context 'with an alternative valid name' do
      it 'does not generate an validation error' do
        contact = build(:contact, :alternative_valid_name)
        contact.valid?

        expect(contact.errors[:name]).to be_empty
      end
    end

    context 'with an invalid name' do
      it 'generates an validation error' do
        contact = build(:contact, :invalid_name)
        contact.valid?

        expect(contact.errors[:name]).to include('is invalid')
      end
    end
  end

  describe 'phone validation' do
    context 'with a valid phone' do
      it 'does not generate an validation error' do
        contact = build(:contact)
        contact.valid?

        expect(contact.errors[:phone]).to be_empty
      end
    end

    context 'with an alternative valid phone' do
      it 'does not generate an validation error' do
        contact = build(:contact, :alternative_valid_phone)
        contact.valid?

        expect(contact.errors[:phone]).to be_empty
      end
    end

    context 'with an invalid phone' do
      it 'generates an validation error' do
        contact = build(:contact, :invalid_phone)
        contact.valid?

        expect(contact.errors[:phone]).to include('is invalid')
      end
    end
  end
end

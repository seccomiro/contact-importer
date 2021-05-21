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

  describe '#email_check' do
    let(:contact) { create(:contact, email: 'contact@email.com') }
    let(:contact_with_same_email) { create(:contact, email: 'contact@email.com') }
    let(:contact_with_different_email) { create(:contact, email: 'another@email.com') }

    context 'with a email check created from a contact email' do
      it 'returns an instance of EmailCheck with the same email' do
        create(:email_check, email: contact.email)

        expect(contact.email_check.email).to eq(contact.email)
      end
    end

    context 'with a email check created from another contact email' do
      it 'returns an instance of EmailCheck with the same email' do
        create(:email_check, email: contact_with_same_email.email)

        expect(contact.email_check.email).to eq(contact.email)
      end
    end

    context 'with no email check created from the contact email yet' do
      it 'returns nil' do
        expect(contact.email_check).to be_nil
      end
    end

    context 'with only a email check created from the email of a contact with different email' do
      it 'returns nil' do
        create(:email_check, email: contact_with_different_email.email)

        expect(contact.email_check).to be_nil
      end
    end
  end
end

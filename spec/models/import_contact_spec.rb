require 'rails_helper'

RSpec.describe ImportContact, type: :model do
  subject { build(:import_contact) }

  describe 'attributes' do
    it { is_expected.to have_attribute(:error_message) }
    it { is_expected.to have_attribute(:name) }
    it { is_expected.to have_attribute(:email) }
    it { is_expected.to have_attribute(:birthdate) }
    it { is_expected.to have_attribute(:phone) }
    it { is_expected.to have_attribute(:address) }
    it { is_expected.to have_attribute(:credit_card_number) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:error_message).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:birthdate).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:address).of_type(:string) }
    it { is_expected.to have_db_column(:import_id).of_type(:integer) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:import_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:import) }
  end

  describe '.importable_attributes' do
    it 'has only the valid importable attributes' do
      expect(described_class.importable_attributes).to contain_exactly(
        :name, :email, :birthdate, :phone, :address, :credit_card_number
      )
    end
  end

  describe '#valid_birthdate?' do
    context 'with valid birthdate' do
      it 'returns true' do
        import_contact = build(:import_contact)
        expect(import_contact.valid_birthdate?).to be(true)
      end
    end

    context 'with alternative valid birthdate' do
      it 'returns true' do
        import_contact = build(:import_contact, :alternative_birthdate)
        expect(import_contact.valid_birthdate?).to be(true)
      end
    end

    context 'with invalid birthdate' do
      it 'returns false' do
        import_contact = build(:import_contact, :invalid_birthdate)
        expect(import_contact.valid_birthdate?).to be(false)
      end
    end
  end

  describe '.with_error' do
    let(:import_contact) { create(:import_contact) }
    let(:import_contact_with_error) { create(:import_contact, :with_error_message) }

    context 'with import error only' do
      it 'returns a list with the wrong import contact' do
        expect(described_class.with_error).to contain_exactly(import_contact_with_error)
      end
    end

    context 'with correct import contacts only' do
      it 'returns an empty list' do
        expect(described_class.with_error).to be_empty
      end
    end

    context 'with a correct and a wrong import contact' do
      it 'returns a list only with the wrong import contact' do
        expect(described_class.with_error).to contain_exactly(import_contact_with_error)
      end
    end
  end

  describe '.without_error' do
    let(:import_contact) { create(:import_contact) }
    let(:import_contact_with_error) { create(:import_contact, :with_error_message) }

    context 'with import error only' do
      it 'returns a list with the correct import contact' do
        expect(described_class.without_error).to contain_exactly(import_contact)
      end
    end

    context 'with wrong import contacts only' do
      it 'returns an empty list' do
        expect(described_class.without_error).to be_empty
      end
    end

    context 'with a correct and a wrong import contact' do
      it 'returns a list only with the correct import contact' do
        expect(described_class.without_error).to contain_exactly(import_contact)
      end
    end
  end
end

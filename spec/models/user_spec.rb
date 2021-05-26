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
end

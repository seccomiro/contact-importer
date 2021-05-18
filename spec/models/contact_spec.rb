require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject { create(:contact) }

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
end

require 'rails_helper'
require_relative '../concerns/credit_card_validable_spec'

RSpec.describe CreditCard, type: :model do
  it_behaves_like 'CreditCardValidable'

  describe 'attributes' do
    it { is_expected.to have_attribute(:number) }
    it { is_expected.to have_attribute(:franchise) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:number).of_type(:string) }
    it { is_expected.to have_db_column(:franchise).of_type(:string) }
    it { is_expected.to have_db_column(:token).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:contact).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:contact) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:franchise) }
  end
end

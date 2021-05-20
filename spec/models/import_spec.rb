require 'rails_helper'

RSpec.describe Import, type: :model do
  describe 'attributes' do
    it { is_expected.to have_attribute(:file) }
    it { is_expected.to have_attribute(:status) }
    it { is_expected.to have_attribute(:headers) }
    it { is_expected.to define_enum_for(:status).with_values({ on_hold: 0, processing: 1, failed: 2, finished: 3 }) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:file).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:headers).of_type(:jsonb) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:import_contacts).dependent(:destroy) }
  end

  describe 'vaidations' do
    it { is_expected.to validate_presence_of(:file) }
  end

  describe 'before_validation' do
    let(:import) { build(:import) }

    context 'without a previous status defined' do
      it 'defines the status as on hold' do
        import = build(:import)
        import.valid?
        expect(import.on_hold?).to be(true)
      end
    end

    context 'with on hold as the previous status' do
      it 'keeps on hold as the status' do
        import = build(:import, status: :on_hold)
        import.valid?
        expect(import.on_hold?).to be(true)
      end
    end

    context 'with any valid previous status except on hold' do
      it 'keeps the current status' do
        status = [:processing, :failed, :finished].sample.to_s
        import = build(:import, status: status)
        import.valid?
        expect(import.status).to eq(status)
      end
    end
  end
end

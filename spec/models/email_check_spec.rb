require 'rails_helper'

RSpec.describe EmailCheck, type: :model do
  subject { build(:email_check) }

  it 'has a valid factory' do
    expect(build(:email_check)).to be_valid
  end

  describe 'attributes' do
    it {
      expect(subject).to define_enum_for(:status)
        .with_values({
                       checking: 0, good: 1, bad: 2,
                       catch_all: 3, unknown: 4, spamtrap: 5, abuse: 6, do_not_mail: 7
                     })
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index([:email]).unique(true) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { is_expected.to respond_to(:contacts) }
      it { is_expected.to respond_to(:register_status) }
    end

    context 'executes methods correctly' do
      let(:contact) { create(:contact, email: 'contact@email.com') }
      let(:email_check) { create(:email_check, email: contact.email) }

      describe '#contacts' do
        let(:contact_with_same_email) { create(:contact, email: 'contact@email.com') }
        let(:contact_with_different_email) { create(:contact, email: 'another@email.com') }

        it 'returns a list of contacts that share the same email address' do
          expect(email_check.contacts).to include(contact, contact_with_same_email)
        end

        it 'does not include a contact with different email' do
          expect(email_check.contacts).not_to include(contact_with_different_email)
        end
      end

      shared_examples_for 'registers valid status for valid input' do |input_status, status|
        let(:email_check) { build(:email_check) }
        before { email_check.register_status(input_status) }

        it { expect(email_check.status.to_sym).to eq(status) }
      end

      describe '#register_status' do
        context 'with valid API statuses responses as input' do
          it_behaves_like 'registers valid status for valid input', 'valid', :good
          it_behaves_like 'registers valid status for valid input', 'invalid', :bad
          it_behaves_like 'registers valid status for valid input', 'catch-all', :catch_all
          it_behaves_like 'registers valid status for valid input', 'unknown', :unknown
          it_behaves_like 'registers valid status for valid input', 'spamtrap', :spamtrap
          it_behaves_like 'registers valid status for valid input', 'abuse', :abuse
          it_behaves_like 'registers valid status for valid input', 'do_not_mail', :do_not_mail
        end

        context 'with valid transient statuses as input' do
          it_behaves_like 'registers valid status for valid input', 'checking', :checking
        end

        context 'with an invalid input status' do
          it 'raises the "Invalid status" error' do
            expect { email_check.register_status('unrecognized') }.to raise_error('Invalid status')
          end
        end
      end
    end
  end

  describe 'before_validation' do
    let(:email_check) { build(:email_check) }

    context 'without a previous status defined' do
      it 'defines the status as checking' do
        email_check = build(:email_check)
        email_check.valid?

        expect(email_check).to be_checking
      end
    end

    context 'with checking as the previous status' do
      it 'keeps checking as the status' do
        email_check = build(:email_check, status: :checking)
        email_check.valid?

        expect(email_check).to be_checking
      end
    end

    context 'with any valid previous status except checking' do
      it 'keeps the current status' do
        status = (described_class.statuses.keys.map(&:to_sym) - [:checking]).sample.to_s
        email_check = build(:email_check, status: status)
        email_check.valid?

        expect(email_check.status).to eq(status)
      end
    end
  end
end

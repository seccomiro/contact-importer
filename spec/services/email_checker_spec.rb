require 'rails_helper'

describe EmailChecker do
  let(:valid_email) { 'valid@email.com' }
  let(:another_valid_email) { 'another@email.com' }
  let(:invalid_email) { 'invalid@email.com' }
  let(:import) { create(:import) }
  let(:import_contact_with_valid_email) { build(:import_contact, email: valid_email, import: import) }
  let(:another_import_contact_with_valid_email) { build(:import_contact, email: another_valid_email, import: import) }
  let(:all_email_check_emails) { EmailCheck.all.map(&:email) }
  let(:first_email_check) { EmailCheck.first }
  let(:client) { double('ZeroBounceClient') }
  let(:zero_bounce_response_for_valid_emails) do
    {
      'email_batch' => [
        { 'address' => valid_email, 'status' => 'valid' },
        { 'address' => another_valid_email, 'status' => 'valid' }
      ]
    }
  end

  describe '#execute' do
    subject(:email_checker) { @email_checker }

    before do
      allow(import).to receive(:import_contacts)
        .and_return([import_contact_with_valid_email, another_import_contact_with_valid_email])

      allow(client).to receive(:fetch)
        .with([valid_email, another_valid_email])
        .and_return(zero_bounce_response_for_valid_emails)

      @email_checker = described_class.new(import, client)
      email_checker.execute
    end

    context 'with an import with valid emails' do
      it 'creates email checks for all the emails' do
        expect(all_email_check_emails).to include(valid_email, another_valid_email)
      end

      # FIX: We cannot test intermediate states right now because we are running synchronously
      # it 'creates email checks with checking status' do
      #   expect(first_email_check).to be_checking
      # end
    end

    context 'with an inline sychronous execution' do
      it 'sets a good status after it ends' do
        expect(first_email_check).to be_good
      end
    end
  end
end

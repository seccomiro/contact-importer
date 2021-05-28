require 'rails_helper'

RSpec.describe EmailCheckerJob, type: :job do
  let(:perform_later) { described_class.perform_later(import) }
  let(:import) { create(:import) }
  let!(:contact) { create(:contact, email: whitelisted_valid_email, user: import.user) }
  let(:whitelisted_valid_email) { 'valid@example.com' }
  let(:zero_bounce_response_for_whitelisted_valid_email) { [{ 'address' => whitelisted_valid_email, 'status' => 'valid' }] }

  include_context 'mocks for ActiveStorage'

  before do
    create(:import_contact, import: import, email: whitelisted_valid_email)

    allow_any_instance_of(ZeroBounceClient).to receive(:fetch)
      .with([whitelisted_valid_email])
      .and_return(zero_bounce_response_for_whitelisted_valid_email)
  end

  describe 'when performing' do
    before { perform_later }

    it 'creates a email check for the email' do
      expect(contact.email_check&.email).to eq(whitelisted_valid_email)
    end

    it 'sets the email check status to good' do
      expect(contact.email_check).to be_good
    end
  end
end

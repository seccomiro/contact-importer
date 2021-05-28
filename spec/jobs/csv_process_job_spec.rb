require 'rails_helper'

RSpec.describe CsvProcessJob, type: :job do
  let(:perform_later) { described_class.perform_later(import) }
  let(:perform_now) { described_class.perform_now(import) }
  let(:file) { file_fixture('1whitelisted.csv') }
  let(:import) { create(:import, file: fixture_file_upload(file, 'text/plain')) }
  let(:whitelisted_valid_email) { 'valid@example.com' }
  let(:zero_bounce_response_for_whitelisted_valid_email) { [{ 'address' => whitelisted_valid_email, 'status' => 'valid' }] }

  include_context 'mocks for ActiveStorage'

  before do
    allow_any_instance_of(ZeroBounceClient).to receive(:fetch)
      .with([whitelisted_valid_email])
      .and_return(zero_bounce_response_for_whitelisted_valid_email)
  end

  describe 'when performing' do
    it 'sets the import status to finished' do
      perform_later

      expect(import.reload).to be_finished
    end

    it 'imports the contacts' do
      expect { perform_later }.to change(Contact, :count).by(1)
    end

    it 'enqueues a EmailCheckerJob', test_jobs_queue: true do
      expect { perform_now }.to have_enqueued_job(EmailCheckerJob).with(import)
    end
  end
end

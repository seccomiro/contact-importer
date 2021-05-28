require 'rails_helper'

RSpec.describe CsvProcessJob, type: :job do
  let(:perform_later) { described_class.perform_later(import) }
  let(:perform_now) { described_class.perform_now(import) }
  let(:import) { create(:import) }

  include_context 'mocks for ActiveStorage'

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '.perform_later' do
    it 'enqueues the job' do
      expect { perform_later }.to have_enqueued_job
    end
  end

  describe '.perform_now' do
    it 'sets the import status to finished' do
      perform_now

      expect(import).to be_finished
    end

    it 'imports the contacts' do
      expect { perform_now }.to change(Contact, :count).by(3)
    end

    it 'enqueues a EmailCheckerJob' do
      perform_now

      expect(EmailCheckerJob).to have_been_enqueued.with(import)
    end
  end
end

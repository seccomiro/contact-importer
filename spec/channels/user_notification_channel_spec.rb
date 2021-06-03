require 'rails_helper'

RSpec.describe UserNotificationChannel, type: :channel do
  subject(:channel) { described_class.new(connection, {}) }

  let(:action_cable) { ActionCable.server }

  context 'with an authenticated user' do
    let(:user) { create(:user) }
    let(:connection) { TestConnection.new(current_user: user) }

    it 'successfully subscribes' do
      subscribe

      expect(subscription).to be_confirmed
    end

    describe '.notify_import_finished' do
      let(:import) { create(:import, user: user) }

      it 'broadcasts the import status' do
        expect(action_cable).to receive(:broadcast).with(user, {
                                                           message: 'The file "3correct.csv" has finished processing.',
                                                           import_id: import.id,
                                                           action: Rails.application.routes.url_helpers.import_path(import)
                                                         }).once

        described_class.notify_import_finished(import)
      end
    end
  end
end

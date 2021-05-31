require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }

  context 'with an authenticated user' do
    before do
      cookies.signed['user.id'] = user.id
      cookies.signed['user.expires_at'] = 10.hours.from_now
    end

    it 'successfully connects' do
      expect { connect '/cable' }.not_to have_rejected_connection
    end

    it 'has the authenticated user as the current user' do
      connect '/cable'

      expect(connection.current_user.id).to eq(user.id)
    end
  end

  context 'with an authenticated user, but session has expired' do
    it 'rejects the connection' do
      cookies.signed['user.id'] = user.id
      cookies.signed['user.expires_at'] = 1.minute.ago

      expect { connect '/cable' }.to have_rejected_connection
    end
  end

  context 'with no user authenticated' do
    it 'rejects the connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end
end

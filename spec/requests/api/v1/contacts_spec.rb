require 'rails_helper'

RSpec.describe 'Api::V1::Contacts', type: :request do
  let(:json) { JSON.parse(response.body) }

  context 'with an authenticated user' do
    let(:user) { create(:user) }
    let(:auth_headers) do
      {
        'Authorization' => "Bearer #{user.token}",
        'Accept' => 'application/json'
      }
    end
    let!(:contact) { create(:contact, credit_card: create(:credit_card), user: user) }

    describe 'GET /api/v1/contacts' do
      before do
        get api_v1_contacts_path, headers: auth_headers
      end

      it_behaves_like 'success JSON response'

      it 'returns a valid list of contacts' do
        expect(json['data']).to include('contacts')
      end

      it 'returns the contacts of the user' do
        expect(json['data']['contacts'].size).to eq(user.contacts.count)
      end

      it 'returns contacts with the correct structure and data' do
        json_contact = json['data']['contacts'].first
        expect(json_contact).to include(
          {
            'id' => contact.id,
            'name' => contact.name,
            'email' => contact.email,
            'phone' => contact.phone,
            'address' => contact.address,
            'credit_card' => {
              'number' => contact.credit_card.number,
              'franchise' => contact.credit_card.franchise
            }
          }
        )
      end
    end
  end

  context 'with a guest' do
    let(:guest_headers) { { 'Accept' => 'application/json' } }

    shared_examples_for 'a user that is not authenticated' do
      it 'returns an error' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns JSON' do
        expect(response.content_type).to include('application/json')
      end

      it 'returns a valid JSON authentication error response' do
        expect(json).to include('status', 'message')
        expect(json['status']).to eq('error')
        expect(json['message']).to eq('You need to sign in or sign up before continuing')
      end
    end

    describe 'GET /api/v1/contacts' do
      before { get api_v1_contacts_path, headers: guest_headers }

      it_behaves_like 'a user that is not authenticated'
    end
  end
end

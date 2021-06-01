require 'rails_helper'

RSpec.describe 'Api::V1::Contacts', type: :request do
  context 'with an authenticated user' do
    let(:user) { create(:user) }
    let(:auth_headers) do
      {
        'Authorization' => "Bearer #{user.token}",
        'Accept' => 'application/json'
      }
    end
    let!(:contacts) { create_list(:contact, 5, credit_card: create(:credit_card), user: user) }

    describe 'GET /index' do
      before do
        get api_v1_contacts_path, headers: auth_headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns JSON' do
        expect(response.content_type).to include('application/json')
      end

      it 'has a valid JSend response' do
        json = JSON.parse(response.body)

        expect(json).to include('status', 'data')
        expect(json['status']).to eq('success')
        expect(json['data']).to include('contacts')
      end

      it 'returns the contacts of the user' do
        json = JSON.parse(response.body)

        expect(json['data']['contacts'].size).to eq(contacts.size)
      end
    end
  end

  # TODO: Add more failing scenarios
  # context 'with a guest' do
  #   let(:guest_headers) do
  #     {
  #       'Accept' => 'application/json'
  #     }
  #   end

  #   before do
  #     get api_v1_contacts_path, headers: guest_headers
  #   end

  #   it 'returns an error' do
  #     get api_v1_contacts_path
  #   end
  # end
end

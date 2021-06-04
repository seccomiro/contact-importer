require 'rails_helper'

RSpec.describe 'Api::V1::Imports', type: :request do
  let(:json) { JSON.parse(response.body) }

  context 'with an authenticated user' do
    let(:user) { create(:user) }
    let(:auth_headers) do
      {
        'Authorization' => "Bearer #{user.token}",
        'Accept' => 'application/json'
      }
    end
    let!(:import) { create(:import, user: user) }

    describe 'GET /api/v1/imports' do
      before do
        get api_v1_imports_path, headers: auth_headers
      end

      it_behaves_like 'success JSON response'

      it 'returns a valid list of imports' do
        expect(json['data']).to include('imports')
      end

      it 'returns the imports of the user' do
        expect(json['data']['imports'].size).to eq(user.imports.count)
      end

      it 'returns imports with the correct structure and data' do
        json_import = json['data']['imports'].first
        expect(json_import).to include(
          {
            'id' => import.id,
            'file_name' => url_for(import.file).split('/').last,
            'file_url' => polymorphic_url(import.file),
            'status' => import.status.to_s.humanize
          }
        )
      end
    end
  end

  context 'with a guest' do
    let(:guest_headers) { { 'Accept' => 'application/json' } }

    describe 'GET /api/v1/imports' do
      before { get api_v1_imports_path, headers: guest_headers }

      include_examples 'for a user that is not authenticated'
    end
  end
end

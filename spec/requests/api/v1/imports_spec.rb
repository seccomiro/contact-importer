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
      context 'without importing errors' do
        before do
          get api_v1_imports_path, headers: auth_headers
        end

        it_behaves_like 'success JSON response'

        it 'returns a list of imports' do
          expect(json['data']).to include('imports')
        end

        it 'returns the imports of the user' do
          expect(json['data']['imports'].size).to eq(user.imports.count)
        end

        it 'returns imports with the correct structure and data' do
          json_import = json['data']['imports'].first
          expect(json_import).not_to include('contacts_with_errors')
        end
      end

      context 'with a finished import with errors' do
        let!(:import) { create(:import, user: user, status: :finished) }
        let!(:import_contact) { create(:import_contact, import: import, error_message: '["Test error"]') }

        before do
          get api_v1_imports_path, headers: auth_headers
        end

        it 'does not return the errors' do
          json_import = json['data']['imports'].first
          expect(json_import).to include(
            {
              'id' => import.id,
              'file_name' => url_for(import.file).split('/').last,
              'file_url' => polymorphic_url(import.file),
              'status' => import.status.to_s.humanize,
              'headers' => import.headers
            }
          )
        end
      end
    end

    describe 'GET /api/v1/imports/:id' do
      context 'without importing errors' do
        let!(:import) { create(:import, user: user) }

        before do
          get api_v1_import_path(import), headers: auth_headers
        end

        it_behaves_like 'success JSON response'

        it 'returns a import' do
          expect(json['data']).to include('import')
        end

        it 'returns a import with the correct structure and data' do
          json_import = json['data']['import']
          expect(json_import).to include(
            {
              'id' => import.id,
              'file_name' => url_for(import.file).split('/').last,
              'file_url' => polymorphic_url(import.file),
              'status' => import.status.to_s.humanize,
              'headers' => import.headers
            }
          )
        end
      end

      context 'with a finished import with errors' do
        let!(:import) { create(:import, user: user, status: :finished) }
        let!(:import_contact) { create(:import_contact, import: import, error_message: '["Test error"]') }

        before do
          get api_v1_import_path(import), headers: auth_headers
        end

        it 'returns a import with its errors' do
          contacts_with_errors = json['data']['import']['contacts_with_errors']
          expect(contacts_with_errors).not_to be_empty
        end
      end
    end
  end

  context 'with a guest' do
    let(:guest_headers) { { 'Accept' => 'application/json' } }

    describe 'GET /api/v1/imports' do
      before { get api_v1_imports_path, headers: guest_headers }

      include_examples 'for a user that is not authenticated'
    end

    describe 'GET /api/v1/imports/:id' do
      before do
        import = create(:import)
        get api_v1_import_path(import), headers: guest_headers
      end

      include_examples 'for a user that is not authenticated'
    end
  end
end

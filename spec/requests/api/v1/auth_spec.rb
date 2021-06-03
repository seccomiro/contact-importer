require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  let(:json) { JSON.parse(response.body) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:email) { 'user@user.com' }
  let(:password) { '123123123' }

  include_context 'with JWT context'

  describe '/api/v1/sign_up' do
    let(:user) { User.find_by(email: user_data[:email]) }

    context 'when the email is not already used' do
      before do
        post api_v1_sign_up_path, headers: headers, params: user_data.to_json
      end

      context 'with valid user data' do
        let(:user_data) { { email: email, password: password, password_confirmation: password } }

        it_behaves_like 'success JSON response'

        it 'returns a user object' do
          expect(json['data']).to include('user')
        end

        it 'returns a user object with correct structure and data' do
          expect(json['data']['user']).to include(
            {
              'email' => user.email,
              'token' => user.token
            }
          )
        end
      end

      context 'without the optional password confirmation' do
        let(:user_data) { { email: email, password: password } }

        it_behaves_like 'success JSON response'

        it 'returns a user object' do
          expect(json['data']).to include('user')
        end

        it 'returns a user object with correct structure and data' do
          expect(json['data']['user']).to include(
            {
              'email' => user.email,
              'token' => user.token
            }
          )
        end
      end

      context 'without a password' do
        let(:user_data) { { email: email } }

        it_behaves_like 'fail JSON response', :unprocessable_entity

        it 'returns the correct error data' do
          expect(json['data']).to include({ 'password' => ["can't be blank"] })
        end
      end

      context 'without an email' do
        let(:user_data) { { password: password } }

        it_behaves_like 'fail JSON response', :unprocessable_entity

        it 'returns the correct error data' do
          expect(json['data']).to include({ 'email' => ["can't be blank"] })
        end
      end

      context 'with a password confirmation different from the password' do
        let(:user_data) { { email: email, password: password, password_confirmation: "#{password}-" } }

        it_behaves_like 'fail JSON response', :unprocessable_entity

        it 'returns the correct error data' do
          expect(json['data']).to include({ 'password_confirmation' => ["doesn't match Password"] })
        end
      end

      context 'without any data' do
        let(:user_data) { nil }

        it_behaves_like 'fail JSON response', :unprocessable_entity

        it 'returns the correct error data' do
          expect(json['data']).to include(
            {
              'email' => ["can't be blank"],
              'password' => ["can't be blank"]
            }
          )
        end
      end
    end

    context 'when the email is already used' do
      let(:user_data) { { email: email, password: password, password_confirmation: password } }

      before do
        create(:user, email: email)
        post api_v1_sign_up_path, headers: headers, params: user_data.to_json
      end

      it_behaves_like 'fail JSON response', :unprocessable_entity

      it 'returns the correct error data' do
        expect(json['data']).to include({ 'email' => ['has already been taken'] })
      end
    end

    # FIXME: This code is intended to test an existing, though invalid, JSON resquest body.
    # It was not possible to find how to make the request with a raw text body.
    # context 'with invalid JSON request body' do
    #   let(:user_data) { 'xxxx' }

    #   before do
    #     post api_v1_sign_up_path, { headers: headers }, params: user_data
    #   end

    #   it 'returns bad request HTTP status' do
    #     expect(response).to have_http_status(:bad_request)
    #   end

    #   it 'returns JSON' do
    #     expect(response.content_type).to include('application/json')
    #   end

    # # FIXME: ActionController::BadRequest must be rescued at middleware level.
    # # SEE: app/controllers/api/v1/concerns/exception_handler.rb
    #   it 'returns the correct error response data' do
    #     expect(json).to include(
    #       {
    #         'status' => 400,
    #         'error' => 'Bad Request'
    #       }
    #     )
    #   end
    # end
  end

  # TODO: Write Sign in specs
end

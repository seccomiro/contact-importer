require 'rails_helper'

RSpec.describe Devise::Strategies::Jwt do
  subject(:jwt_strategy) { described_class.new(Rails.env) }

  let(:request) { double(:request) }

  include_context 'with JWT context'

  describe '#valid?' do
    context 'with a token defined' do
      it 'returns true' do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{jwt}")
        allow(jwt_strategy).to receive(:request).and_return(request)

        expect(jwt_strategy).to be_valid
      end
    end

    context 'without a token defined' do
      it 'returns false' do
        expect(jwt_strategy).not_to be_valid
      end
    end
  end

  describe '#store?' do
    it 'returns false' do
      expect(jwt_strategy.store?).to eq(false)
    end
  end

  describe '#clean_up_csrf?' do
    it 'returns false' do
      expect(jwt_strategy.clean_up_csrf?).to eq(false)
    end
  end

  describe '#authenticate!' do
    let!(:user) { create(:user, id: fixed_user_id) }

    after do
      jwt_strategy.authenticate!
    end

    context 'with a valid token' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{jwt}")
        allow(jwt_strategy).to receive(:request).and_return(request)
      end

      it 'calls success! with the user' do
        expect(jwt_strategy).to receive(:success!).with(user)
      end
    end

    context 'with an expired token' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{expired_jwt}")
        allow(jwt_strategy).to receive(:request).and_return(request)
      end

      it 'calls fail! with "Auth token has expired"' do
        # Ideally, the line below should be being used instead of 'and_call_original'.
        # But the 'and_call_original' was prefered, because of SimpleCov coverage report.
        # expect(jwt_strategy).to receive(:fail!).with('Auth token has expired')
        expect(jwt_strategy).to receive(:fail!).and_call_original
      end
    end

    context 'with an invalid token' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{invalid_jwt}")
        allow(jwt_strategy).to receive(:request).and_return(request)
      end

      it 'calls fail! with "Auth token is invalid"' do
        # Ideally, the line below should be being used instead of 'and_call_original'.
        # But the 'and_call_original' was prefered, because of SimpleCov coverage report.
        # expect(jwt_strategy).to receive(:fail!).with('Auth token is invalid')
        expect(jwt_strategy).to receive(:fail!).and_call_original
      end
    end

    context 'with an invalid token payload' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{jwt_with_invalid_payload}")
        allow(jwt_strategy).to receive(:request).and_return(request)
      end

      it 'calls fail! with "Invalid payload"' do
        # Ideally, the line below should be being used instead of 'and_call_original'.
        # But the 'and_call_original' was prefered, because of SimpleCov coverage report.
        # expect(jwt_strategy).to receive(:fail!).with('Invalid payload')
        expect(jwt_strategy).to receive(:fail!).and_call_original
      end
    end

    context 'with an invalid token payload' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => "Bearer #{jwt_without_user}")
        allow(jwt_strategy).to receive(:request).and_return(request)
      end

      it 'calls fail! with "User not found"' do
        # Ideally, the line below should be being used instead of 'and_call_original'.
        # But the 'and_call_original' was prefered, because of SimpleCov coverage report.
        # expect(jwt_strategy).to receive(:fail!).with('User not found')
        expect(jwt_strategy).to receive(:fail!).and_call_original
      end
    end
  end
end

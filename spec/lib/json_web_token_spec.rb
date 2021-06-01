require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:raw_data) { { id: 10 } }
  let(:decoded_jwt) { { 'exp' => 2.weeks.from_now.to_i, 'id' => 10 } }
  let(:encoded_data) { 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTAsImV4cCI6MTYyMzc3ODk4MH0.wvoGAyT7cQnq0RZ36idgLaEnRUCVHk5UtbeFRAbhFJ0' }
  let(:secret_key_base) { 'ccaa18eb8a8022812602b4290ccbc165a5ae9524c56f31b13aeef45e885af7595591250818b736dc59bfa722d85122593476d8e2098f5bd19a41376903aafcd2' }
  let(:fixed_date) { DateTime.parse('2021-06-01T14:43:00-03:00') }

  before do
    travel_to fixed_date
    allow(Rails.application).to receive(:secret_key_base).and_return(secret_key_base)
  end

  after do
    travel_back
  end

  describe '.encode' do
    it 'encodes the data' do
      expect(described_class.encode(raw_data)).to eq(encoded_data)
    end
  end

  describe '.decode' do
    it 'encodes the data' do
      expect(described_class.decode(encoded_data)).to eq(decoded_jwt)
    end
  end
end

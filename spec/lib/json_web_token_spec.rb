require 'rails_helper'

RSpec.describe JsonWebToken do
  include_context 'with JWT context'

  describe '.encode' do
    it 'encodes the data' do
      expect(described_class.encode(raw_data)).to eq(jwt)
    end
  end

  describe '.decode' do
    it 'encodes the data' do
      expect(described_class.decode(jwt)).to eq(decoded_jwt)
    end
  end
end

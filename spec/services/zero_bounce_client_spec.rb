require 'rails_helper'

describe ZeroBounceClient do
  subject(:client) { described_class.new }

  let(:valid_email) { 'valid@email.com' }
  let(:invalid_email) { 'invalid@email.com' }
  let(:api_url) { 'https://bulkapi.zerobounce.net/v2/validatebatch' }
  let(:valid_email_request_body) do
    {
      'api_key' => ENV['ZEROBOUNCE_API_KEY'],
      'email_batch' => [
        { 'email_address' => valid_email, 'ip_address' => nil }
      ]
    }
  end
  let(:valid_email_response_body) do
    {
      'email_batch' => [
        { 'email_address' => valid_email, 'status' => 'valid' }
      ]
    }
  end
  let(:empty_request_body) do
    { 'api_key' => ENV['ZEROBOUNCE_API_KEY'], 'email_batch' => [] }
  end
  let(:empty_response_body) do
    { 'email_batch' => [], 'errors' => [] }
  end

  describe '#fetch' do
    before do
      stub_request(:post, api_url)
        .with(body: valid_email_request_body.to_json)
        .to_return(body: valid_email_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: empty_request_body.to_json)
        .to_return(body: empty_response_body.to_json)
    end

    it 'requests ZeroBounce API endpoint' do
      client.fetch([valid_email])

      expect(WebMock).to have_requested(:post, api_url)
        .with(
          body: valid_email_request_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        ).once
    end

    context 'with a valid email' do
      subject { client.fetch([valid_email]) }

      it { is_expected.to include(valid_email_response_body) }
    end

    context 'without any email' do
      subject { client.fetch([]) }

      it { is_expected.to include('email_batch' => []) }
      it { is_expected.to include('errors') }
    end
  end
end

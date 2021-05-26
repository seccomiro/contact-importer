require 'rails_helper'

describe ZeroBounceClient do
  subject(:client) { described_class.new }

  let(:valid_email) { 'valid@email.com' }
  let(:invalid_email) { 'invalid@email.com' }
  let(:api_url) { 'https://bulkapi.zerobounce.net/v2/validatebatch' }
  let(:api_key) { 'api_key' }
  let(:whitelisted_email) { described_class.whitelist.first }
  let(:not_whitelisted_email) { 'not_whitelisted@email.com' }
  let(:valid_email_request_body) do
    {
      'api_key' => api_key,
      'email_batch' => [
        { 'email_address' => valid_email, 'ip_address' => nil }
      ]
    }
  end
  let(:valid_email_response_body) do
    {
      'email_batch' => [
        { 'email_address' => valid_email, 'status' => 'valid' }
      ], 'errors' => []
    }
  end
  let(:empty_request_body) do
    { 'api_key' => api_key, 'email_batch' => [] }
  end
  let(:empty_response_body) do
    { 'email_batch' => [], 'errors' => [
      { 'error' => 'Error message', 'email_address' => 'all' }
    ] }
  end
  let(:error_request_body) do
    {
      'api_key' => nil,
      'email_batch' => [
        { 'email_address' => valid_email, 'ip_address' => nil }
      ]
    }
  end
  let(:error_response_body) do
    { 'email_batch' => [
      { 'email_address' => valid_email, 'status' => 'valid' }
    ], 'errors' => [
      { 'error' => 'Error message', 'email_address' => 'all' }
    ] }
  end
  let(:whitelisted_email_request_body) do
    {
      'api_key' => api_key,
      'email_batch' => [
        { 'email_address' => whitelisted_email, 'ip_address' => nil }
      ]
    }
  end
  let(:whitelisted_email_response_body) do
    {
      'email_batch' => [
        { 'address' => whitelisted_email, 'status' => 'valid' }
      ], 'errors' => []
    }
  end

  let(:not_whitelisted_email_request_body_with_whitelist_disabled) do
    {
      'api_key' => api_key,
      'email_batch' => [
        { 'email_address' => not_whitelisted_email, 'ip_address' => nil }
      ]
    }
  end
  let(:not_whitelisted_email_resonse_body_with_whitelist_disabled) do
    {
      'email_batch' => [not_whitelisted_email_result_with_whitelist_disabled], 'errors' => []
    }
  end
  let(:whitelisted_and_not_whitelisted_email_request_body_with_whitelist_disabled) do
    {
      'api_key' => api_key,
      'email_batch' => [
        { 'email_address' => whitelisted_email, 'ip_address' => nil },
        { 'email_address' => not_whitelisted_email, 'ip_address' => nil },
      ]
    }
  end
  let(:whitelisted_and_not_whitelisted_email_resonse_body_with_whitelist_disabled) do
    {
      'email_batch' => [whitelisted_email_result, not_whitelisted_email_result_with_whitelist_disabled], 'errors' => []
    }
  end

  let(:whitelisted_email_result) { { 'address' => whitelisted_email, 'status' => 'valid' } }
  let(:not_whitelisted_email_result) { { 'address' => not_whitelisted_email, 'status' => 'not_whitelisted' } }
  let(:not_whitelisted_email_result_with_whitelist_disabled) { { 'address' => not_whitelisted_email, 'status' => 'valid' } }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('ZEROBOUNCE_ALLOW_ONLY_WHITELISTED').and_return('false')
    allow(ENV).to receive(:[]).with('ZEROBOUNCE_API_KEY').and_return(api_key)
  end

  describe '#fetch' do
    before do
      stub_request(:post, api_url)
        .with(body: valid_email_request_body.to_json)
        .to_return(body: valid_email_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: empty_request_body.to_json)
        .to_return(body: empty_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: error_request_body.to_json)
        .to_return(body: error_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: error_request_body.to_json)
        .to_return(body: error_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: whitelisted_email_request_body.to_json)
        .to_return(body: whitelisted_email_response_body.to_json)
      stub_request(:post, api_url)
        .with(body: not_whitelisted_email_request_body_with_whitelist_disabled.to_json)
        .to_return(body: not_whitelisted_email_resonse_body_with_whitelist_disabled.to_json)
      stub_request(:post, api_url)
        .with(body: whitelisted_and_not_whitelisted_email_request_body_with_whitelist_disabled.to_json)
        .to_return(body: whitelisted_and_not_whitelisted_email_resonse_body_with_whitelist_disabled.to_json)
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

      it { is_expected.to match_array(valid_email_response_body['email_batch']) }
    end

    context 'without any email' do
      subject { client.fetch([]) }

      it { is_expected.to eq([]) }
    end

    context 'with an actual error' do
      subject { client.fetch([valid_email]) }

      before do
        allow(ENV).to receive(:[]).with('ZEROBOUNCE_API_KEY').and_return(nil)
      end

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context 'with email whitelisting enabled' do
      before do
        allow(ENV).to receive(:[]).with('ZEROBOUNCE_ALLOW_ONLY_WHITELISTED').and_return('true')
      end

      context 'with a whitelisted email' do
        subject { client.fetch([whitelisted_email]) }

        it { is_expected.to eq([whitelisted_email_result]) }
      end

      context 'with an email not whitelisted' do
        subject { client.fetch([not_whitelisted_email]) }

        it { is_expected.to eq([not_whitelisted_email_result]) }

        it 'returns a list containing the not whitelisted email with status not whitelisted' do
          expect(subject).to contain_exactly(not_whitelisted_email_result)
        end
      end

      context 'with a whitelisted email and an email not whitelisted' do
        subject { client.fetch([whitelisted_email, not_whitelisted_email]) }

        it { expect(subject).to contain_exactly(not_whitelisted_email_result, whitelisted_email_result) }
      end
    end

    context 'with email whitelisting disabled' do
      before do
        allow(ENV).to receive(:[]).with('ZEROBOUNCE_ALLOW_ONLY_WHITELISTED').and_return('false')
      end

      context 'with a whitelisted email' do
        subject { client.fetch([whitelisted_email]) }

        it { is_expected.to eq([whitelisted_email_result]) }
      end

      context 'with an email not whitelisted' do
        subject { client.fetch([not_whitelisted_email]) }

        it { is_expected.to eq([not_whitelisted_email_result_with_whitelist_disabled]) }

        it 'returns a list containing the not whitelisted email with status not whitelisted' do
          expect(subject).to contain_exactly(not_whitelisted_email_result_with_whitelist_disabled)
        end
      end

      context 'with a whitelisted email and an email not whitelisted' do
        subject { client.fetch([whitelisted_email, not_whitelisted_email]) }

        it { expect(subject).to contain_exactly(not_whitelisted_email_result_with_whitelist_disabled, whitelisted_email_result) }
      end
    end
  end

  describe '.whitelist' do
    let(:filename) { Rails.root.join('lib/assets/zero_bounce_whitelist.yml') }
    let(:whitelist_from_file) { YAML.load_file(filename)['whitelist'] }

    it 'returns the correct ZeroBounce whitelist from the YAML file' do
      expect(described_class.whitelist).to match_array(whitelist_from_file)
    end
  end

  describe '#whitelisted?' do
    let(:whitelisted_email) { described_class.whitelist.first }
    let(:not_whitelisted_email) { 'a_not_whitelisted@email.com' }

    context 'with email whitelisting enabled' do
      before do
        allow(ENV).to receive(:[]).with('ZEROBOUNCE_ALLOW_ONLY_WHITELISTED').and_return('true')
      end

      context 'with a whitelisted email' do
        it 'returns true' do
          expect(client.whitelisted?(whitelisted_email)).to be(true)
        end
      end

      context 'with a not whitelisted email' do
        it 'returns false' do
          expect(client.whitelisted?(not_whitelisted_email)).to be(false)
        end
      end
    end

    context 'with email whitelisting disabled' do
      before do
        allow(ENV).to receive(:[]).with('ZEROBOUNCE_ALLOW_ONLY_WHITELISTED').and_return('false')
      end

      context 'with a whitelisted email' do
        it 'returns true' do
          expect(client.whitelisted?(whitelisted_email)).to be(true)
        end
      end

      context 'with a not whitelisted email' do
        it 'returns true' do
          expect(client.whitelisted?(not_whitelisted_email)).to be(true)
        end
      end
    end
  end
end

RSpec.shared_examples_for 'success JSON response' do
  it 'returns http success' do
    expect(response).to have_http_status(:success)
  end

  it 'returns JSON' do
    expect(response.content_type).to include('application/json')
  end

  it 'returns a valid JSend response' do
    expect(json).to include('status', 'data')
    expect(json['status']).to eq('success')
  end
end

RSpec.shared_examples_for 'fail JSON response' do |http_status|
  it "returns #{http_status} HTTP status" do
    expect(response).to have_http_status(http_status)
  end

  it 'returns JSON' do
    expect(response.content_type).to include('application/json')
  end

  it 'returns a valid JSend response' do
    expect(json).to include('status', 'data')
    expect(json['status']).to eq('fail')
  end
end

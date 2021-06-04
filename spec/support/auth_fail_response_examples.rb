shared_examples_for 'for a user that is not authenticated' do
  it 'returns an error' do
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns JSON' do
    expect(response.content_type).to include('application/json')
  end

  it 'returns a valid JSON authentication error response' do
    expect(json).to include('status', 'message')
    expect(json['status']).to eq('error')
    expect(json['message']).to eq('You need to sign in or sign up before continuing')
  end
end

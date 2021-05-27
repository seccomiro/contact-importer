RSpec.shared_context 'stubs for ActiveStorage' do
  before do
    stub_request(:get, /active_storage/)
      .to_return(
        status: 200,
        body: ->(request) { File.new(file_fixture(request.uri.to_s.split('/').last)) }
      )
  end
end

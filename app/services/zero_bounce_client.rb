class ZeroBounceClient
  def initialize
    @api_key = ENV['ZEROBOUNCE_API_KEY']
  end

  def fetch(emails)
    uri = URI('https://bulkapi.zerobounce.net/v2/validatebatch')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {
      api_key: @api_key,
      email_batch: emails.map do |e|
        {
          'email_address' => e,
          'ip_address' => nil
        }
      end
    }
    res = http.request(req)

    JSON.parse(res.body)
  end
end

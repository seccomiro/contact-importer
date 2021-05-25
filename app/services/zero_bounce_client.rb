class ZeroBounceClient
  def initialize
    @api_key = ENV['ZEROBOUNCE_API_KEY']
    @whitelist = whitelist
    @allow_only_whitelisted = ENV['ZEROBOUNCE_ALLOW_ONLY_WHITELISTED'] == 'true'
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
    }.to_json
    res = http.request(req)

    JSON.parse(res.body)
  end

  # private

  # This list is needed to avoid charging the real ZeroBounce account credits
  def whitelist
    yaml = YAML.load_file(Rails.root.join('lib/assets/zero_bounce_whitelist.yml'))
    yaml['whitelist']
  end

  def whitelisted?(email)
    @whitelist.include?(email) || !@allow_only_whitelisted
  end
end

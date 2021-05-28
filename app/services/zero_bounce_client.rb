class ZeroBounceClient
  def initialize
    @api_key = ENV['ZEROBOUNCE_API_KEY']
    @allow_only_whitelisted = ENV['ZEROBOUNCE_ALLOW_ONLY_WHITELISTED'] == 'true'
  end

  def fetch(emails)
    whitelisted_emails = emails.filter { |email| whitelisted?(email) }
    return not_whitelisted_results(emails) if whitelisted_emails.none?

    uri = URI('https://bulkapi.zerobounce.net/v2/validatebatch')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {
      api_key: @api_key,
      email_batch: whitelisted_emails.map { |email| { 'email_address' => email, 'ip_address' => nil } }
    }.to_json
    res = http.request(req)

    result = JSON.parse(res.body)
    raise StandardError, result['errors'] if result['errors'].any? && result['email_batch'].any?

    result['email_batch'] + not_whitelisted_results(emails)
  end

  # This list is needed to avoid charging the real ZeroBounce account credits
  def self.whitelist
    yaml = YAML.load_file(Rails.root.join('lib/assets/zero_bounce_whitelist.yml'))
    yaml['whitelist']
  end

  def whitelisted?(email)
    whitelist.include?(email) || !@allow_only_whitelisted
  end

  private

  def not_whitelisted_results(emails)
    emails
      .filter { |email| !whitelisted?(email) }
      .map do |email|
        { 'address' => email, 'status' => 'not_whitelisted' }
      end
  end

  def whitelist
    @whitelist ||= ZeroBounceClient.whitelist
  end
end

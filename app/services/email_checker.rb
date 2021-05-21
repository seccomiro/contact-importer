class EmailChecker
  attr_writer :client

  def initialize(import, client = nil)
    @import = import
    @client = client || ZeroBounceClient.new
  end

  def execute
    @import.import_contacts.each do |import_contact|
      EmailCheck.create(email: import_contact.email)
    end
    all_emails = @import.import_contacts.map(&:email)
    response = @client.fetch(all_emails)
    response['email_batch'].each do |email|
      email_check = EmailCheck.find_by(email: email['address'])
      email_check.register_status(email['status'])
      email_check.save
    end
  end
end

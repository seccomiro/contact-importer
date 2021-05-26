class EmailChecker
  attr_writer :client

  def initialize(import, client = nil)
    @import = import
    @client = client || ZeroBounceClient.new
  end

  def execute
    import_emails = @import.import_contacts.pluck(:email).uniq & @import.user.contacts.pluck(:email)
    existing_emails = EmailCheck.where(email: import_emails).pluck(:email)
    new_emails = import_emails - existing_emails
    new_emails.each do |email|
      EmailCheck.create(email: email)
    end
    response = @client.fetch(new_emails)
    response.each do |email|
      # begin
      email_check = EmailCheck.find_by(email: email['address'])
      # rescue
      #   byebug
      # end
      email_check.register_status(email['status'])
      email_check.save
    end
  end
end

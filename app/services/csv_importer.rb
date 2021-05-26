require 'csv'
require 'down'

class CsvImporter
  def initialize(import)
    @import = import
    @tempfile = if Rails.env.production?
                  Down.download(@import.file.url).path
                else
                  "#{Rails.root}/public#{Import.last.file.url}"
                end
  end

  def fetch_headers
    CSV.open(@tempfile, &:readline).first.split(';')
       .map { |h| { h => '' } }
       .reduce({}) { |acc, h| acc.merge(h) }
  end

  def execute
    CSV.foreach(@tempfile, headers: true, encoding: 'utf-8', col_sep: ';') do |line|
      import_contact = @import.import_contacts.build
      @import.headers.each do |header, db_column|
        import_contact[db_column.to_sym] = line[header]
      end
      import_contact.save
      generate_contact(import_contact)
    end
    @import.status = @import.import_contacts.without_error.any? ? :finished : :failed
    @import.save
  end

  def generate_contact(import_contact)
    contact = @import.user.contacts.create(
      name: import_contact.name,
      email: import_contact.email,
      birthdate: import_contact.valid_birthdate? ? DateTime.parse(import_contact.birthdate) : nil,
      phone: import_contact.phone,
      address: import_contact.address,
      credit_card_attributes: {
        number: import_contact.credit_card_number
      }
    )
    import_contact.error_message = contact.errors.full_messages.to_json unless contact.valid?
    import_contact.save
    import_contact
  end
end

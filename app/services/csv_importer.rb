require 'csv'

class CsvImporter
  def initialize(import)
    @import = import
  end

  def fetch_headers
    CSV.open(@import.file.path, &:readline).first.split(';')
       .map { |h| { h => '' } }
       .reduce({}) { |acc, h| acc.merge(h) }
  end

  def execute
    import
  end

  private

  def import
    CSV.foreach(@import.file.path, headers: true, encoding: 'utf-8', col_sep: ';') do |line|
      import_contact = @import.import_contacts.build
      @import.headers.each do |header, db_column|
        import_contact[db_column.to_sym] = line[header]
      end
      import_contact.save
      generate_contact(import_contact)
    end
    @import.status = :finished
    @import.save
  end

  def generate_contact(import_contact)
    @import.user.contacts.create(
      name: import_contact.name,
      email: import_contact.email,
      birthdate: Date.parse(import_contact.birthdate),
      phone: import_contact.phone,
      address: import_contact.address,
      credit_card_attributes: {
        number: import_contact.credit_card_number
      }
    )
  end
end

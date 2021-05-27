require 'rails_helper'

describe CsvImporter do
  include_context 'mocks for ActiveStorage'

  describe '#fetch_headers' do
    it 'returns a Hash with the headers of the CSV' do
      import = create(:import, file: fixture_file_upload('3correct.csv', 'text/plain'))
      csv_importer = described_class.new(import)

      expect(csv_importer.fetch_headers).to match(
        'name' => '',
        'email' => '',
        'birthdate' => '',
        'phone' => '',
        'address' => '',
        'credit_card' => ''
      )
    end
  end

  describe '#execute' do
    context 'with a file with 3 correct contacts' do
      let(:file) { file_fixture('3correct.csv') }
      let(:import) { create(:import, file: fixture_file_upload(file, 'text/plain')) }
      let(:csv_importer) { described_class.new(import) }

      before do
        csv_importer.execute
      end

      it 'creates 3 import contacts' do
        expect(import.import_contacts.count).to eq(3)
      end

      it 'creates 3 contacts' do
        expect(Contact.count).to eq(3)
      end

      it 'creates valid contacts' do
        expect(Contact.all.all?(&:valid?)).to be(true)
      end
    end

    context 'with a file with 5 contacts with errors' do
      let(:file) { file_fixture('5error.csv') }
      let(:import) { create(:import, file: fixture_file_upload(file, 'text/plain')) }
      let(:csv_importer) { described_class.new(import) }

      before do
        csv_importer.execute
      end

      it 'creates 5 import contacts' do
        expect(import.import_contacts.count).to eq(5)
      end

      it 'does not create any contacts' do
        expect(Contact.count).to eq(0)
      end
    end

    context 'with a file with 1 correct contact and 3 contacts with errors' do
      let(:file) { file_fixture('1correct-3error.csv') }
      let(:import) { create(:import, file: fixture_file_upload(file, 'text/plain')) }
      let(:csv_importer) { described_class.new(import) }

      before do
        csv_importer.execute
      end

      it 'creates 4 import contacts' do
        expect(import.import_contacts.count).to eq(4)
      end

      it 'creates 1 contact' do
        expect(Contact.count).to eq(1)
      end

      it 'creates valid contacts' do
        expect(Contact.all.all?(&:valid?)).to be(true)
      end
    end
  end

  describe '#generate_contact' do
    let(:file) { file_fixture('3correct.csv') }
    let(:import) { create(:import, file: fixture_file_upload(file, 'text/plain')) }
    let(:import_contact) { create(:import_contact, import: import) }
    let(:csv_importer) { described_class.new(import) }
    let(:contact) { csv_importer.generate_contact(import_contact) }

    context 'with a valid import contact' do
      it 'generates a contact with correct data' do
        expect(contact).to have_attributes(
          name: import_contact.name,
          email: import_contact.email,
          phone: import_contact.phone,
          address: import_contact.address,
          birthdate: DateTime.parse(import_contact.birthdate)
        )
      end

      it 'generates a valid contact' do
        expect(contact).to be_valid
      end
    end
  end
end

require 'rails_helper'

RSpec.feature 'Import creation', type: :feature do
  context 'with an authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    scenario 'User creates an import' do
      visit new_import_path

      expect(page).to have_field('File')

      attach_file 'File', file_fixture('3correct.csv')
      click_on 'Create Import'

      expect(page).to have_text('On hold')
      expect(page).to have_current_path(import_path(user.imports.last))
    end

    scenario 'User can assign CSV attributes to system attributes' do
      import = create(:import, user: user)
      options = ImportContact.importable_attributes.map(&:to_s)

      visit import_path(import)

      expect(page).to have_text('On hold')
      expect(page).to have_selector('.attributes')
      expect(page).to have_selector('.attributes .file-header', text: 'name')
      expect(page).to have_selector('.attributes .file-header', text: 'email')
      expect(page).to have_selector('.attributes .file-header', text: 'phone')
      expect(page).to have_selector('.attributes .file-header', text: 'address')
      expect(page).to have_selector('.attributes .file-header', text: 'birthdate')
      expect(page).to have_selector('.attributes .file-header', text: 'credit_card')
      all('.attributes .system-attribute').each do |item|
        expect(item).to have_select(with_options: options)
      end
    end

    scenario 'User assigns attributes and starts processing an import' do
      import = create(:import, :empty_headers, user: user)

      visit import_path(import)

      expect(page).to have_button('Assign Attributes')
      expect(page).not_to have_link('Process File')

      select 'name', from: 'file_header[name]'
      select 'email', from: 'file_header[email]'
      select 'phone', from: 'file_header[phone]'
      select 'address', from: 'file_header[address]'
      select 'birthdate', from: 'file_header[birthdate]'
      select 'credit_card_number', from: 'file_header[credit_card]'

      click_on 'Assign Attributes'

      expect(page).to have_link('Process File')

      click_on 'Process File'

      expect(page).to have_current_path(import_path(import))
      expect(page).to have_text('Processing')
    end

    scenario 'User starts processing a file with errors' do
      import = create(:import, user: user, file: File.open(file_fixture('5error.csv')))

      visit import_path(import)

      expect(page).to have_link('Process File')

      Sidekiq::Testing.inline! do
        click_on 'Process File'

        visit import_path(import)

        expect(page).to have_text('Failed')
        expect(page).to have_selector('.failing-contacts')
      end
    end

    context 'with attributes not yet assigned' do
      scenario 'User assigns attributes and starts processing an import' do
        import = create(:import, :empty_headers, user: user)

        visit import_path(import)
        click_on 'Assign Attributes'

        expect(page).not_to have_link('Process File')
      end
    end
  end

  context 'with a guest' do
    scenario 'User is redirected to the sign in page' do
      visit imports_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

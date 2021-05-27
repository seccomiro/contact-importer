require 'rails_helper'

RSpec.feature 'Import visualization', type: :feature do
  include_context 'stubs for ActiveStorage'

  context 'with an authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'with several imports created' do
      before do
        create(:import, user: user, status: :on_hold)
        create(:import, user: user, status: :processing)
        create(:import, user: user, status: :failed)
        create(:import, user: user, status: :finished)
      end

      scenario 'User sees the import list' do
        visit imports_path

        expect(page).to have_selector('.imports')
        expect(page).to have_css('.imports th', count: 3)
        expect(page).to have_css('.imports tbody tr', count: 4)
        expect(page).to have_text('On hold')
        expect(page).to have_text('Processing')
        expect(page).to have_text('Failed')
        expect(page).to have_text('Finished')
      end
    end

    context 'with only one "on hold" import created' do
      let(:file) { file_fixture('3correct.csv') }
      let(:import) { create(:import, user: user, file: fixture_file_upload(file, 'text/plain')) }

      scenario 'User sees a link to explore the details of a import' do
        import
        visit imports_path

        expect(page).to have_link(href: import_path(import))

        click_link(href: import_path(import))

        expect(page).to have_current_path(import_path(import))
      end

      scenario 'User sees the details of a import' do
        visit import_path(import)

        expect(page).to have_text(import.file.filename)
        expect(page).to have_text('On hold')
      end
    end

    context 'with only one "finished" import created without errors' do
      let(:file) { file_fixture('3correct.csv') }
      let(:import) { create(:import, user: user, file: fixture_file_upload(file, 'text/plain')) }

      before do
        CsvImporter.new(import).execute
      end

      scenario 'User sees the details of a import' do
        visit import_path(import)

        expect(page).to have_text(import.file.filename)
        expect(page).to have_text('Finished')
        expect(page).not_to have_selector('failing-contacts')
      end
    end

    context 'with only one "failed" import created' do
      let(:file) { file_fixture('5error.csv') }
      let(:import) { create(:import, user: user, file: fixture_file_upload(file, 'text/plain')) }

      before do
        CsvImporter.new(import).execute
      end

      scenario 'User sees the details of a import' do
        visit import_path(import)

        expect(page).to have_text(import.file.filename)
        expect(page).to have_text('Failed')
        expect(page).to have_selector('.failing-contacts')
        expect(page).to have_selector('.failing-contacts tbody tr', count: 5)
      end
    end

    context 'with only one "finished" import created, but with errors' do
      let(:file) { file_fixture('1correct-3error.csv') }
      let(:import) { create(:import, user: user, file: fixture_file_upload(file, 'text/plain')) }

      before do
        CsvImporter.new(import).execute
      end

      scenario 'User sees the details of a import' do
        visit import_path(import)

        expect(page).to have_text(import.file.filename)
        expect(page).to have_text('Finished')
        expect(page).to have_selector('.failing-contacts')
        expect(page).to have_selector('.failing-contacts tbody tr', count: 3)
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

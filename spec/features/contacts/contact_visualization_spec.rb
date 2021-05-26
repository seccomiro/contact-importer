require 'rails_helper'

RSpec.feature 'Contact visualization', type: :feature do
  context 'with an authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'with a contact list' do
      before do
        create_list(:contact, 3, user: user, credit_card: build(:credit_card))
      end

      scenario 'User sees the contact list' do
        visit contacts_path

        expect(page).to have_selector('.contacts')
        expect(page).to have_css('.contacts th', count: 7)
        expect(page).to have_css('.contacts tbody tr', count: 3)
      end

      context 'with only one page of contacts' do
        scenario 'User does not see pagination' do
          visit contacts_path

          expect(page).not_to have_selector('.pagination')
        end
      end

      context 'with more than one page of contacts' do
        scenario 'User sees pagination' do
          visit contacts_path(params: { per_page: 2 })

          expect(page).to have_selector('.pagination')
          expect(page).to have_selector('.previous_page')
          expect(page).to have_selector('.next_page')
          expect(page).to have_link('2', href: contacts_path(params: { page: 2, per_page: 2 }))

          click_link('2')

          expect(page).to have_link('1', href: contacts_path(params: { page: 1, per_page: 2 }))
          expect(page).to have_selector('.current', text: '2')
        end
      end

      context 'with a different user also with contacts' do
        let(:another_user) { create(:user) }

        before do
          create(:contact, user: another_user, credit_card: build(:credit_card))
          visit contacts_path
        end

        scenario 'User only sees its own contacts' do
          expect(page).to have_css('.contacts tbody tr', count: 3)
        end
      end
    end

    context 'with a single contact' do
      let(:contact) { create(:contact, user: user, credit_card: build(:credit_card)) }

      before do
        contact
      end

      context 'without a email check created' do
        scenario 'User sees the status of the emails' do
          visit contacts_path

          expect(page).to have_text('Not checked')
        end
      end

      context 'with a email check just created' do
        scenario 'User sees the status of the emails' do
          create(:email_check, email: contact.email)

          visit contacts_path

          expect(page).to have_text('Checking')
        end
      end

      context 'with a email check already checked' do
        scenario 'User sees the status of the emails' do
          email_check = create(:email_check, email: contact.email, status: :good)

          visit contacts_path

          expect(page).to have_text(email_check.status.to_s.humanize)
        end
      end
    end
  end

  context 'with a guest' do
    scenario 'User is redirected to the sign in page' do
      visit contacts_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

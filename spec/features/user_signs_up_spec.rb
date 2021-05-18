require 'rails_helper'

describe 'User signs up' do
  let(:user) { build(:user) }

  it 'with valid data' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', id: 'user_password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'Sign up'

    expect(page).to have_text 'Welcome! You have signed up successfully.'
    expect(page).to have_link 'Sign Out'
    expect(page).to have_current_path root_path
  end

  it 'with invalid data' do
    visit new_user_registration_path

    click_button 'Sign up'

    expect(page).to have_text "Email can't be blank"
    expect(page).to have_text "Password can't be blank"
    expect(page).to have_no_link 'Sign Out'
  end
end

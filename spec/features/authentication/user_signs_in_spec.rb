require 'rails_helper'

describe 'User signs in' do
  let(:user) { create(:user) }
  let(:nonexisting_user) { build(:user, email: 'invalid@user.com') }

  it 'with valid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_text 'Signed in successfully.'
    expect(page).to have_link 'Sign Out'
    expect(page).to have_current_path root_path
  end

  it 'with invalid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: nonexisting_user.email
    fill_in 'Password', with: nonexisting_user.password
    click_button 'Log in'

    expect(page).to have_text 'Invalid Email or password.'
    expect(page).to have_no_link 'Sign Out'
  end
end

require 'rails_helper'

describe 'User signs out' do
  let(:user) { create(:user) }

  it 'user signed in' do
    sign_in user

    visit root_path

    click_link 'Sign Out'

    expect(page).to have_text 'Signed out successfully.'
    expect(page).to have_no_link 'Sign Out'
    expect(page).to have_current_path root_path
  end
end

require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an authenthicated user
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenthicated user tries to sign out' do
    visit root_path
    click_on 'Sign out'
    
    expect(page).to have_content 'Signed out successfully.'
  end
end

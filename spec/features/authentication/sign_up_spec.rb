# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  describe 'Unregistered user' do
    scenario 'tries to sign up with valid attributes' do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'

      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with invalid attributes' do
      fill_in 'Email', with: 'user@test.com'

      click_button 'Sign up'
      expect(page).to have_content 'error prohibited this user from being saved'
    end
  end

  scenario 'Already registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end

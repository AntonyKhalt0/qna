require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question)}

  scenario 'Unauthenthicated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenthicated user', js: true do
    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with error' do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to_not have_content 'edited answer'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Another authenthicated user tries to edit otheer user's answer", js: true do
    sign_in another_user

    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end
end

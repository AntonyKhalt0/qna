require 'rails_helper'

feature 'User can edit question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenthicated user can not edit question', js: true do
    visit question_path(question)

    expect(find('.question')).to_not have_content 'Edit'
  end

  describe 'Authenthicated user', js: true do
    background do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edits his question' do
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with error' do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'his a question with attached file' do
      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "Another authenthicated user tries to edit otheer user's answer", js: true do
    sign_in another_user
    visit question_path(question)

    expect(find('.question')).to_not have_link 'Edit'
  end
end

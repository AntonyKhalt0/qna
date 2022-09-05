require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer to another user
  As an authenthicated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenthicated user', js: true do

    background do 
      sign_in(user)
      
      visit question_path(question)
    end

    scenario 'give an answer' do
      fill_in 'Your answer', with: 'Answer text'
      click_on 'Post answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Answer text'
    end

    scenario 'give an answer with error' do
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'give a answer with attached file' do
      fill_in 'Your answer', with: 'Answer text'
      
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenthicated user tries to give an answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on 'Post answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

require 'rails_helper'

feature 'User can create comment for answer', %q{
  In order to get comment from a community
  As an authenthicated user
  I'd like to be able to write my comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  describe 'Authenthicated user', js: true do

    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write comment for answer' do
      within '.answer-new-comment' do
        fill_in 'comment_body', with: 'Comment text'
        click_on 'Comment'
      end

      expect(page).to have_content 'Comment text'
    end
  end

  context 'multiple sessions', js: true do
    scenario "answer comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer-new-comment' do
          fill_in 'comment_body', with: 'Comment text'
          click_on 'Comment'
        end

        expect(page).to have_content 'Comment text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment text'
      end
    end
  end

  scenario 'Unauthenthicated user tries to write comment for answer', js: true do
    visit question_path(question)

    expect(page).to_not have_button 'Comment'
  end
end

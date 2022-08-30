require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to get best answer from a community
  As an question author
  I'd like to be able to choose the best answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question_id: question.id, author: user) }

  scenario 'Unauthenticated user tries to choose the best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  scenario 'Other user tries to choose the best answer', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Question author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can view link' do
      expect(page).to have_link 'Best answer'
    end

    scenario 'can choose the best answer' do
      click_on 'Best answer'
    
      expect(page).to have_content 'Best answer this question'
    end
  end
end

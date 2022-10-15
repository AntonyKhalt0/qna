# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for resources', "
    In order to get best answer from a community
    As an user
    I'd like to be able to search for the resource
  " do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  background { visit questions_path }

  scenario 'User searches with no result', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_data', with: 'blabla'
      select('All', from: 'search_type')
      click_on 'Search'

      expect(page).to have_content 'No matches'
    end
  end

  scenario 'User searches with question', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_data', with: question.title
      select('Question', from: 'search_type')
      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'User searches with answer', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_data', with: answer.body
      select('Answer', from: 'search_type')
      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end
end

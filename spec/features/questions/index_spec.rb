# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question', "
  In order to view all quesitons
  As an unauthenthicated user
  I'd like to be able to view the question
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'Unauthenthicated user view a questions' do
    visit questions_path

    expect(page).to have_link 'Ask question', href: new_question_path
    expect(page).to have_content 'MyQuestionTitle', count: 3
  end
end

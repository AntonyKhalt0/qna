require 'rails_helper'

feature 'User can view question and answers', %q{
  In order to view all answer for question
  As an unauthenthicated user
  I'd like to be able to view the question and answers
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }
  
  scenario 'Unauthenthicated user view a questions' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'AnswerBody', count: 6
  end

end

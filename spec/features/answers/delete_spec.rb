require 'rails_helper'

feature 'User can create question', %q{
  In order to delete written answer
  As an authenthicated user
  I'd like to be able to delete the answer
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question_id: question.id, author: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user delete him answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    within '.answers' do
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'Authenticated user delete not him answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end

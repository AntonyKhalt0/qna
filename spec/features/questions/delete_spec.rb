# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenthicated user
  I'd like to be able to ask the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user delete him quesiton' do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Questions'
  end

  scenario 'Authenticated user delete not him quesiton' do
    sign_in(another_user)
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end

# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional to my answer
  As an question author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/AntonyKhalt0/b1ad3ef255da79d7f84e264da5dd0210' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My Answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the question the like', "
  In order to express my opinion
  As an not question author
  I'd like to be able to vote for question
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'views like and dislike links' do
    sign_in(user)
    visit questions_path

    expect(page).to have_link 'Like'
    expect(page).to have_link 'Dislike'
  end

  describe 'User', js: true do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'tries to vote for question' do
      within '.votes' do
        click_on 'Like'

        expect(page).to have_content '1'
      end
    end

    scenario 'tries to downvote for question' do
      within '.votes' do
        click_on 'Dislike'

        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to unvote for question' do
      within '.votes' do
        click_on 'Like'
        click_on 'Unvote'

        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'tries to vote for question' do
      click_on 'Like'

      expect(page).to have_content "Author can't vote"
    end
  end
end

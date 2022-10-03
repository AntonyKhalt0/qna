# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the answer the like', "
  In order to express my opinion
  As an not answer author
  I'd like to be able to vote for answer
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, author: author, question: question) }

  scenario 'views like and dislike links' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'Like'
    expect(page).to have_link 'Dislike'
  end

  describe 'User', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to vote for answer' do
      within '.votes' do
        click_on 'Like'

        expect(page).to have_content '1'
      end
    end

    scenario 'tries to downvote for answer' do
      within '.votes' do
        click_on 'Dislike'

        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to unvote for answer' do
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
      visit question_path(question)
    end

    scenario 'tries to vote for answer' do
      click_on 'Like'

      expect(page).to have_content "Author can't vote"
    end
  end
end

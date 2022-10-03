# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { login(user) }

  describe 'POST #create' do
    it 'saves a new questions notifier in the database' do
      expect { post :create, params: { question_id: question.id } }.to change(QuestionSubscription, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:question_subscription) { create(:question_subscription, user: user, question: question) }

    it 'deletes the question notifier' do
      expect { delete :destroy, params: { id: question_subscription } }.to change(QuestionSubscription, :count).by(-1)
    end
  end
end

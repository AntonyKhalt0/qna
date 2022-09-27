# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question_id: question.id, author: user) }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saved a new answer for question in database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question.id },
                        format: :js
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid_body),
                                  question_id: question.id,
                                  format: :js }
        end.to_not change(Answer, :count)
      end
    end

    it 'renders create template' do
      post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js }
      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'saved a edit answer' do
        patch :update, params: { id: answer, answer: { body: 'Editing answer' }, format: :js }
        answer.reload

        expect(answer.body).to eq 'Editing answer'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_body) }, format: :js }
      it 'does not saved edit answer' do
        answer.reload

        expect(answer.body).to eq 'AnswerBody'
      end
    end

    it 'renders update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question_id: question.id, author: user) }

    it 'deletes the answer' do
      expect do
        delete :destroy, params: { id: answer, question_id: question.id }, format: :js
      end.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: answer, question_id: question.id }, format: :js
      expect(response).to render_template :destroy
    end
  end
end

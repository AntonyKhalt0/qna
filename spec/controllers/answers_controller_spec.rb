require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question_id: question.id) }

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saved a new answer for question in database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { 
                                          question_id: question.id, 
                                          answer: attributes_for(:answer, :invalid_body) } 
                                       }.to_not change(Answer, :count)
      end
    end

    it 'redirect to show question view' do
      post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
      expect(response).to redirect_to question
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'saved a edit answer' do
        patch :update, params: { id: answer, question_id: question.id, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, question_id: question.id, answer: attributes_for(:answer, :invalid_body) } }
      it 'does not saved edit answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end
    end

    it 'redirect to show question view' do
      patch :update, params: { id: answer, question_id: question.id, answer: attributes_for(:answer) }
      expect(response).to redirect_to question
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question_id: question.id) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer, question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question
    end
  end
end

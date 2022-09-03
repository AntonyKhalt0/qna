require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question_id: question.id, author: user)}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user)}

    before { get :index }

    it 'populates an array of all quesitons' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question }, format: :js }

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end    
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question }, format: :js }

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'resirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'assigns the request question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'resirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do  
        question.reload

        expect(question.title).to eq 'MyQuestionTitle'
        expect(question.body).to eq 'MyQuestionBody'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update_best_answer', js: true do
    before { login(user) }
    let!(:question) { create(:question, author: user) }
    let!(:answers) { create_list(:answer, 3, question_id: question.id, author: user) }

    it 'make best answer' do
      patch :update_best_answer, params: { id: question, question: { best_answer_id: answers[0].id } }, format: :js
      question.reload

      expect(question.best_answer).to eq answer[0]
    end
  end
  
  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question, author: user) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end

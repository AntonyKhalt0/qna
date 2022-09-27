require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }
  let(:user) { create(:user)}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id title body created_at updated_at best_answer_id award_id rating] }
        let(:resource_response) { question_response }
        let(:resource) { questions.first }
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'API public fields' do
          let(:public_fields) { %w[id body created_at updated_at author_id question_id rating] }
          let(:resource_response) { answer_response }
          let(:resource) { answers.first }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id title body created_at updated_at best_answer_id award_id rating] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it 'contains comment objects' do
        expect(question_response['comments']).to eq question.comments
      end

      it 'contains links objects' do
        expect(question_response['links']).to eq question.links
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'successfully save new question in database' do
          expect { post api_path,
            params: { access_token: access_token.token, question: attributes_for(:question) },
            headers: headers }.to change(Question, :count).by(1)
        end

        context 'return question json' do
          before { post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers }

          it_behaves_like 'API public fields' do
            let(:public_fields) { %w[title body] }
            let(:resource_response) { json['question'] }
            let(:resource) { create(:question, author: user) }
          end
        end
      end

      context 'with invalid attributes' do
        it "don't save new question in database" do
          expect { post api_path,
            params: { access_token: access_token.token, question: attributes_for(:question,:invalid) },
            headers: headers }.to_not change(Question, :count)
        end

        it_behaves_like 'API error response'
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'successfully update question' do
        patch api_path, params: { access_token: access_token.token, id: question.id, question: { title: 'test question' } }, headers: headers
        question.reload

        expect(question.title).to eq 'test question'
      end

      context 'return question json' do
        before { patch api_path, params: { access_token: access_token.token, question: { title: 'test question' } }, headers: headers }

        it_behaves_like 'API public fields' do
          let(:public_fields) { %w[title body] }
          let(:resource_response) { json['question'] }
          let(:resource) { question.reload }
        end
      end
    end

    context 'unauthorized' do
      it 'dont update question' do
        patch api_path, params: { access_token: access_token.token, id: question.id, question: attributes_for(:question) }, headers: headers
        question.reload

        expect(question.title).to eq 'MyQuestionTitle'
      end

      it_behaves_like 'API error response'
    end
  end

  describe 'DELETE #destroy' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'question author' do
        it 'successfully delete question' do
          expect { delete api_path,
            params: { access_token: user_access_token.token, id: question },
            headers: headers }.to change(Question, :count).by(-1)
        end
      end

      context 'not question author' do
        it 'dont successfully delete question' do
          expect { delete api_path,
            params: { access_token: other_access_token.token, id: question },
            headers: headers }.to_not change(Question, :count)
        end
      end
    end
  end
end

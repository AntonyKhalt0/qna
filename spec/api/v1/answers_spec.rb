require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }
  let(:user) { create(:user)}
  let(:question) { create(:question, author: user) }

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token, question_id: question.id }, headers: headers }

      it_behaves_like 'API success response'

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id body created_at updated_at author_id question_id rating] }
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end

      it 'contains comment objects' do
        expect(answer_response['comments']).to eq answer.comments
      end

      it 'contains links objects' do
        expect(answer_response['links']).to eq answer.links
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'successfully save new answer in database' do
          expect { post api_path,
            params: { access_token: access_token.token, question_id: question.id, answer: attributes_for(:answer) },
            headers: headers }.to change(Answer, :count).by(1)
        end

        context 'return answer json' do
          before { post api_path, params: { access_token: access_token.token, question_id: question.id, answer: attributes_for(:answer) }, headers: headers }

          it_behaves_like 'API public fields' do
            let(:public_fields) { %w[body] }
            let(:resource_response) { json['answer'] }
            let(:resource) { create(:answer, question: question, author: user) }
          end
        end
      end

      context 'with invalid attributes' do
        it "don't save new answer in database" do
          expect { post api_path,
            params: { access_token: access_token.token, question_id: question.id, answer: attributes_for(:answer, :invalid_body) },
            headers: headers }.to_not change(Answer, :count)
        end

        it_behaves_like 'API error response' do
          let(:resource) { :answer }
          let(:trait) { :invalid_body }
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'successfully update answer' do
        patch api_path, params: { access_token: access_token.token, id: answer.id, answer: { body: 'test body' } }, headers: headers
        answer.reload

        expect(answer.body).to eq 'test body'
      end

      context 'return answer json' do
        before { patch api_path, params: { access_token: access_token.token, id: answer.id, answer: { body: 'test body' } }, headers: headers }

        it_behaves_like 'API public fields' do
          let(:public_fields) { %w[body] }
          let(:resource_response) { json['answer'] }
          let(:resource) { answer.reload }
        end
      end
    end

    context 'unauthorized' do
      it 'dont update answer' do
        patch api_path, params: { access_token: access_token.token, id: answer.id, answer: attributes_for(:answer) }, headers: headers
        answer.reload

        expect(answer.body).to eq 'AnswerBody'
      end

      it_behaves_like 'API error response' do
        let(:resource) { :answer }
        let(:trait) { :invalid_body }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'answers author' do
        it 'successfully delete answer' do
          expect { delete api_path,
            params: { access_token: user_access_token.token, question_id: question.id, id: answer },
            headers: headers }.to change(Answer, :count).by(-1)
        end
      end

      context 'not question author' do
        it 'dont successfully delete answer' do
          expect { delete api_path,
            params: { access_token: other_access_token.token, question_id: question.id, id: answer },
            headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end
end

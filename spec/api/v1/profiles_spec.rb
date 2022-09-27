require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json }
        let(:resource) { me }
      end

      it_behaves_like 'API private fields' do
        let(:private_fields) { %w[password encrypted_password] }
        let(:resource_response) { json }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }
      let(:profile_response) { json.first }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it 'return list of profiles' do
        expect(json.size).to eq 2
      end

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { profile_response }
        let(:resource) { users.second }
      end

      it_behaves_like 'API private fields' do
        let(:private_fields) { %w[password encrypted_password] }
        let(:resource_response) { profile_response }
      end

      it 'does not contains user object' do
        json.each do |attr|
          expect(attr['id']).to_not eq users.first.id
        end
      end
    end
  end
end

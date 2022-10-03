require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
  
    before do
      session['omniauth_data'] = {
        :provider => 'vkontakte',
        :uid => '1234567',
        'access_token' => 'token'
      }
    end

    it 'find user for oauth data' do
      expect(User).to receive(:find_for_oauth).and_return(user)

      post :create, params: { user: { email: 'user@example.com' } }
    end

    it 'user saved and redirect to root path' do
      allow(User).to receive(:find_for_oauth).and_return(user)
      post :create, params: { user: { email: 'user@example.com' } }

      expect(response).to redirect_to root_path
    end

    it "user don't saved and redirect to root path" do
      allow(User).to receive(:find_for_oauth).and_return(nil)
      post :create, params: { user: { email: 'user@example.com' } }

      expect(response).to redirect_to root_path
    end
  end
end

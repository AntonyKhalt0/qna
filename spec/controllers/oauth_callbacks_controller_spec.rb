require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do        
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do        
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path if user does not exist' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { mock_auth_hash(:vkontakte) }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_by_authorization).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do        
        allow(User).to receive(:find_by_authorization).with(oauth_data).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do        
        allow(User).to receive(:find_by_authorization).with(oauth_data).and_return(nil)
        get :vkontakte
      end

      it 'writing user credentials in session' do
        allow(User).to receive(:build_vkontakte_auth_hash).with(oauth_data)
        expect(session['omniauth_data']).to be_present
        get :vkontakte
      end

      it 'render confirmation page for new user' do
        allow(User).to receive(:build_vkontakte_auth_hash).with(oauth_data)
        expect(response).to render_template 'users/registration_email'
      end
    end
  end
end

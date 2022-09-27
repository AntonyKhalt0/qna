# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[:vkontake] = {
      :provider => provider.to_s,
      :uid => '1234567',
      :info => {
        email: email,
        name: 'mockuser',
        image: 'mock_user_url'
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    }
  end
end

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    auth = request.env['omniauth.auth']
    @user = User.find_by_authorization(auth)

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      session['omniauth_data'] = User.build_vkontakte_auth_hash(auth)
      flash[:alert] = 'You need to enter your email and confirm him'
      render 'users/registration_email'
    end
  end
end
  

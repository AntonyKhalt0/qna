class AccountsController < ApplicationController
  def create
    @user = User.find_for_oauth(create_user_data)    
  
    if @user&.persisted?
      redirect_to root_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def create_user_data
    data = {}
    data[:provider] = session['omniauth_data']['provider']
    data[:uid] = session['omniauth_data']['uid']
    data[:info] = { email: user_params[:email] }
    data
  end
end

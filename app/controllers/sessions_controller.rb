class SessionsController < ApplicationController
  before_action :logout_required, only: %i[login create]
  before_action :login_required, only: %i[destroy]

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      log_in @user
      flash[:notice] = 'You are logged in!'
      redirect_to @user
    else
      flash[:alert] = 'Invalid email/password combination, try again!'
      redirect_to sessions_login_path
    end
  end

  def destroy
    log_out
    flash[:notice] = 'You are logged out!'
    redirect_to users_path
  end
end

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def logged_out?
    current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Checks if the logged in user is the owner to edit/update/delete profile.
  def profile_authorization
    return if current_user.id == @user.id

    flash[:alert] = 'You must be logged in as this user to view this page.'
    redirect_to users_url
  end

  def login_required
    return if current_user

    flash[:alert] = 'You must be logged in to view this page.'
    redirect_to sessions_login_path
  end

  def logout_required
    return if current_user.nil?

    flash[:alert] = 'You must be logged out to view this page.'
    redirect_to users_path
  end

  def require_admin!
    redirect_to root_path, notice: 'You are not authorized to perform this action.' unless current_user.admin?
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    return if logged_in?

    flash[:alert] = 'You must be logged in to perform that action'
    redirect_to login_path
  end

  def require_same_user
    if @current_user != @host
      flash[:alert] = 'You can only access your own dashboard'
      redirect_to user_dashboard_index_path(@current_user)
    end
  end

  helper_method :current_user, :logged_in?, :require_user, :require_same_user
end

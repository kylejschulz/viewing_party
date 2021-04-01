class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password]) && user.email_confirmed
      successful_create(user)
    elsif user && user.authenticate(params[:password]) && !user.email_confirmed
      email_not_confirmed
    else
      flash[:error] = 'Credentials do not match'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:message] = 'You have been logged out'
    redirect_to root_path
  end

  private

  def successful_create(user)
    session[:user_id] = user.id
    flash[:success] = "Welcome #{user.full_name}"
    redirect_to user_dashboard_index_path(user)
  end

  def email_not_confirmed
    flash[:error] = 'Please activate your account by visiting the confirmation email you received'
    render :new
  end
end

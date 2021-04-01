class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    @user = User.create(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:error] = 'Please activate your account by following the
      instructions in the account confirmation email you received to proceed'
      redirect_to login_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def confirm_email
    @user = User.find(params[:id])
    @user.email_activate
    flash[:success] = "Welcome to the Viewing Party! Your email has been confirmed.
    Please sign in to continue."
    redirect_to login_path
  end

  private

  def user_params
    params.permit(:full_name, :email, :password, :password_confirmation)
  end
end

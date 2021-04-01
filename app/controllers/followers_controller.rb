class FollowersController < ApplicationController
  def create
    user = User.find(params[:user_id])
    friend = User.find_by(email: params[:search])
    if !friend.nil? && params[:search] != user.email
      Follow.create(follower_id: friend.id, followee_id: user.id)
      flash[:success] = "Successfully Added #{friend.full_name}"
    elsif params[:search] == user.email
      flash[:error] = 'You Can Not Add Yourself'
    else
      flash[:error] = 'This User Does Not Exist'
    end
    redirect_to user_dashboard_index_path(user)
  end
end

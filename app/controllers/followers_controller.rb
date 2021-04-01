class FollowersController < ApplicationController
  def create
    user = User.find(params[:user_id])
    friend = User.find_by(email: params[:search])
    if !friend.nil? && params[:search] != user.email
      Follow.create(follower_id: friend.id, followee_id: user.id)
      flash[:success] = "Successfully Added #{friend.full_name}"
    else
      flash[:error] = 'Check email is valid and not your own'
    end
    redirect_to user_dashboard_index_path(user)
  end
end

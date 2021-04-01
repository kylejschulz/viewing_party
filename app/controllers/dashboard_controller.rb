class DashboardController < ApplicationController
  before_action :set_host, :require_user, :require_same_user

  def index
    @host = User.find(params[:user_id])
    @hosted_parties = @host.parties
    @invited_parties = @host.parties_im_invited_to
  end

  private

  def set_host
    @host = User.find(params[:user_id])
  end
end

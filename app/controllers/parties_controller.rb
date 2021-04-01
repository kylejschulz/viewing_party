class PartiesController < ApplicationController
  before_action :logged_in?, :require_user

  def new
    @movie = MovieService.movie_object(params[:movie_id])
    @followers = @current_user.followers
  end

  def create
    @movie = MovieService.movie_object(params[:movie_id])
    @movie_db = Movie.find_or_create_by(id: @movie.id, title: @movie.title)
    @party = Party.new(party_params)
    if @party.save
      @invitees = Invitee.create_multiple_invitees(params[:friends], @party.id)

      flash[:success] = 'Your Viewing Party Has Been Created!'
      redirect_to user_dashboard_index_path(@current_user)
    else
      flash[:error] = @party.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def party_params
    params.permit(:movie_id, :user_id, :duration, :time, :date)
  end
end

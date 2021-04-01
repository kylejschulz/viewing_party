class MoviesController < ApplicationController
  before_action :require_user, :logged_in?

  def index
    if params[:search]
      @movies = MovieService.movie_search_objects(params[:search])
      @movies_partial = MovieService.no_movies?(params[:search])
    elsif params[:top_forty]
      @movies = MovieService.top_forty_objects
      @movies_partial = MovieService.top_forty_partial
    else
      redirect_to discover_index_path
    end
  end

  def show
    @movie ||= MovieService.movie_object(params[:id])
    @genres = @movie.genres
    @cast = @movie.first_10_cast_members
    @reviews = @movie.review_authors
  end
end

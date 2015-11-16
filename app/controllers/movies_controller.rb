class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    session[:column] = params[:column] if params[:column]
    session[:ratings] = params[:ratings] if params[:ratings] && !params[:ratings].empty?
    
    @movies = Movie.all
    unless session[:column] == nil || !(Movie.column_names.include? session[:column].to_s)
      @selected_column = session[:column].to_sym
      @movies.order!(@selected_column)
    end
    
    @selected_ratings = @all_ratings
    @selected_ratings = @all_ratings & session[:ratings].keys unless session[:ratings] == nil
    @movies.where!("rating IN (?)", @selected_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

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
    
    @all_ratings = Movie.all.sort_by{|x| x[:rating]}.map{|x| x.rating}.uniq
    @selected_ratings = with_ratings
    @selected_ratings.each do |rating|
        params[:rating] = true
    end
    
    if params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.where(:rating => @selected_ratings)
    end
  end
  
  # Takes an array pf ratings and return matched ones
  def with_ratings
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
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

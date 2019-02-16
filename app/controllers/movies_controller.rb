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
    @all_ratings = Movie.all.sort_by{|x| x[:rating]}.map{|x| x.rating}.uniq  # find the rating list by consulting the model
    redirect = false  # determine if the page needs to be redirected
    
    # Use seesion to store passed parameter
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      redirect = true
    else
      @sort = nil
    end
      
    if params[:commit]== "Refresh" and params[:ratings].nil?
      @ratings = nil
      session[:ratings] = nil
    elsif params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    end
      
    # Get the redirect page
    if redirect
      flash.keep
      redirect_to movies_path :sort=> @sort, :ratings=> @ratings
    end
    
    # If none of the box is checked, return the page with no results
    if @ratings.nil?
      @ratings = Hash.new
    end
    
    # Display the page according to the filter and sort options
    if @sort and @ratings
       @movies = Movie.where(:rating => @ratings.keys).order(@sort)
    elsif @sort
       @movies = Movie.order(@sort)
    elsif @ratings
       @movies = Movie.where(:rating => @ratings.keys)
    else
       @movies = Movie.all
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

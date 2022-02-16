class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    #get Movie ratings
    @all_ratings = Movie.movieRatings
    
    @ratingsChecked = params[:ratings]
    @prevSession = session[:filter]
    if @ratingsChecked
      #get keys of the checked ratings
      @ratings= params[:ratings].keys
      #remeber in sessions what keys have been previously checked
      session[:filter] = @ratings
    elsif session[:filter]
      #restore previous session ratings 
      @ratings = @prevSession
    else
      @ratings = @all_ratings
    end
    #added on 15-02
    #where is used to filter queries so that we can get only those which we have specified 
    #where! is destructive in nature
    @movies.where!(:rating => @ratings)
    
    @sortby= params[:target]
    if @sortby=='title'
      @title_header= 'hilite'
      sortedby = {:sorted => :title }
      @movies = Movie.order @sortby
    elsif @sortby=='release_date'
      @release_date_header= 'hilite'
      sortedby ={ :sorted => :release_date }
      @movies = Movie.order @sortby
    else
    end
    #@movies = Movie.order sortby
    
    # 1. how to figure out which boxes the user checked and 
    # 2. how to restrict the database query based on that result.
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

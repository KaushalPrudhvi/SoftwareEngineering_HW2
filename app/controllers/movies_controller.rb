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

    if params[:targetSort].nil? && params[:ratings].nil? && (session[:targetSort].nil? || !session[:ratings].nil?)
       redirect_to movies_path({:targetSort => session[:targetSort], :ratings => session[:ratings]})
    end
    
    
      
    
    @ratingsChecked = params[:ratings]
    @prevCheckedSession = session[:ratings]
    if @ratingsChecked
      #get keys of the checked ratings
      @ratings= params[:ratings].keys
      
      #remeber in sessions what keys have been previously checked
      session[:ratings] = @ratingsChecked
    elsif session[:ratings]
      #restore previous session ratings 
      @ratings = session[:ratings].keys
      
    else
      @ratings = @all_ratings
      
    end
    
    #added on 15-02
    #where is used to filter queries so that we can get only those which we have specified 
    #where! is destructive in nature
    @movies.where!(:rating => @ratings)

    
    @sortby= params[:targetSort] 
    
    if @sortby
    
    
      if @sortby== 'title'
        @title_header= 'hilite'
        @movies = Movie.order("#{@sortby} ASC")
        session[:targetSort]=  "title"
        
      elsif @sortby== 'release_date'
        @release_date_header= 'hilite'
        @movies = Movie.order("#{@sortby} ASC")
        session[:targetSort]=  "release_date"
      
      end
    end
      
    
    
  end
=begin  
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
=end
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

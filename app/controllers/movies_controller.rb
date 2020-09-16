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
    @all_ratings = ["G", "PG", "PG-13", "R"]
    
    @ratings_picked = []
    @sort_got = ""
    red = false
    
    if params[:sort]
      @sort_got = params[:sort]
      session[:sort] = @sort_got
    elsif session[:sort]
      @sort_got = session[:sort]
      red = true
    else
      @sort = nil
    end
    
    if params[:ratings]
      params[:ratings].each {|k, v| @ratings_picked << k} # since array of hash
      session[:ratings] = @ratings_picked
    elsif session[:ratings]
        @ratings_picked = session[:ratings]
        red = true
    else
        @ratings_picked = nil
    end
    
    if red
      redirect_to movies_path(:ratings => @ratings_picked, :sort => @sort_got)
    else
      @movies = Movie.with_ratings(@ratings_picked).order(@sort_got)
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
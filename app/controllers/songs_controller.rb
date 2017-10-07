require 'pry'

class SongsController < ApplicationController
  def index
    if params[:artist_id]
      binding.pry
      @artist = Artist.find(params[:artist_id])
      if @artist.valid?
        @songs = @artist.songs
      else
        redirect artists_path
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      if Artist.find(params[:artist_id])
        @song = Song.find(params[:id])
      else
        redirect_to artists_path
      end
      if !@song.valid?
        redirect_to artist_songs_path(:artist_id)
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

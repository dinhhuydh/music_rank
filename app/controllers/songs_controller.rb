class SongsController < ApplicationController
  def index
    @songs = Song.all
    respond_to do |format|
      format.html
      format.json
    end
  end

  def increase_viewer
    song = Song.find(params[:id])
    song.increase_viewer
    render :nothing => true
  end
end

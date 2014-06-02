class SongsController < ApplicationController
  def index
    @songs = Song.all
    @user = User.create

    respond_to do |format|
      format.html
      format.json
    end
  end

  def increase_viewer
    song = Song.find(params[:id])
    user = User.find_by_id(params[:user_id])
    old_song = Song.find_by_id(params[:old_song_id])
    song.increase_viewer
    song.add_listener(user)
    if old_song
      old_song.remove_listener(user)
      MyPubnub.instance.publish(old_song.users, old_song.channel)
    end
    MyPubnub.instance.publish(song.users, song.channel)
    render :json => song.users
  end
end

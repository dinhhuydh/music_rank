require 'pubnub'

class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment :file, :presence => true, :content_type => { :content_type => "audio/mp3" }
  has_many :users_songs
  has_many :users, through: :users_songs, dependent: :destroy

  def increase_viewer
    increment!(:viewer_count)
    MyPubnub.instance.publish(Song.ordered_songs, "myChannel")
  end

  def self.ordered_songs
    Song.order("viewer_count DESC").each_with_index.map { |song, index|  [song.id, index] }
  end

  def add_listener user
    users_songs.create(:user => user)
  end

  def remove_listener user
    users_songs.where(:user => user).destroy_all
  end

  def channel
    "song_channel_#{id}"
  end
end

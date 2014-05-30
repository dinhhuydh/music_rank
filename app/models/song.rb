require 'pubnub'

class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment :file, :presence => true, :content_type => { :content_type => "audio/mp3" }

  def increase_viewer
    increment!(:viewer_count)
    MyPubnub.instance.publish(Song.ordered_songs, "myChannel")
  end

  def self.ordered_songs
    Song.order("viewer_count DESC").each_with_index.map { |song, index|  [song.id, index] }
  end
end

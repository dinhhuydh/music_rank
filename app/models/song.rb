class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment :file, :presence => true, :content_type => { :content_type => "audio/mp3" }

  def increase_viewer
    increment!(:viewer_count)
  end
end

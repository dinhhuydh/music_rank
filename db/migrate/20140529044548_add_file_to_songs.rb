class AddFileToSongs < ActiveRecord::Migration
  def self.up
    add_attachment :songs, :file
  end

  def self.down
    remove_attachment :songs, :file
  end
end

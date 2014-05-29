class AddViewerCountToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :viewer_count, :integer, :default => 0
  end
end

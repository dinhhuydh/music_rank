class CreateUsersSongs < ActiveRecord::Migration
  def change
    create_table :users_songs do |t|
      t.integer :song_id
      t.integer :user_id

      t.timestamps
    end
  end
end

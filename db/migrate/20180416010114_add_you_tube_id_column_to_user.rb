class AddYouTubeIdColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :video_id, :string
  end
end

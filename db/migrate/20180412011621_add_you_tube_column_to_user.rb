class AddYouTubeColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :yt_url, :string
  end
end

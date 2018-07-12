class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :artist
      t.string :song
      t.integer :user_id

      t.timestamps
    end
    add_index :favorites, [:user_id, :created_at]
  end
end

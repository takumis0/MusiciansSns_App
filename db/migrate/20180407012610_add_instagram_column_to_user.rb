class AddInstagramColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :insta_id, :string
  end
end

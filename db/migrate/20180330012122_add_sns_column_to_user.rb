class AddSnsColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :contact_adress, :string
    add_column :users, :tw_id, :string
    add_column :users, :fb_id, :string
    add_column :users, :line_id, :string
  end
end

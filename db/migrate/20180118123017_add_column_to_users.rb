class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduction, :string
    add_column :users, :birthday, :integer
    add_column :users, :address, :integer
  end
end

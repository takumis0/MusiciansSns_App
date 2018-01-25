class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduction, :string
    add_column :users, :birthday, :date
    add_column :users, :prefecture_code, :integer
  end
end

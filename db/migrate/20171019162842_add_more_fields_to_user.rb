class AddMoreFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string 
    add_column :users, :name, :string
    add_column :users, :email, :string
    add_column :users, :image_url, :string
    add_column :users, :token, :string
  end
end

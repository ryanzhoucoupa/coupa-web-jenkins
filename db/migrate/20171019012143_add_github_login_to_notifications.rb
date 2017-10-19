class AddGithubLoginToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :github_login, :string, index: true
  end
end

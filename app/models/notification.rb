class Notification < ApplicationRecord
  belongs_to :user, foreign_key: :github_login, primary_key: :github_login
end

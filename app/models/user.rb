class User < ApplicationRecord
  has_many :notifications, primary_key: :github_login, foreign_key: :github_login
end

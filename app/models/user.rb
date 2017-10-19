class User < ApplicationRecord
  validates_uniqueness_of :github_login
  has_many :notifications, primary_key: :github_login, foreign_key: :github_login
end

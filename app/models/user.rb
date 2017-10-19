class User < ApplicationRecord
  validates_uniqueness_of :github_login
  has_many :notifications, primary_key: :github_login, foreign_key: :github_login

  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid'])
    user.github_login = auth['info']['nickname']
    user.nickname = auth['info']['nickname']
    user.name = auth['info']['name']
    user.email = auth['info']['email']
    user.image_url = auth['info']['image']
    user.token = auth['credentials']['token']

    user.save!
    user
  end
end

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

    user.save
    user
  end

  def self.current_user
    Thread.current[:user]
  end

  def self.current_user=(newUser)
    Rails.logger.warn("User.current_user= was called with an object not of the User class! Expected User but got '#{newUser.class}'!") unless newUser.nil? || newUser.kind_of?(User)
    Thread.current[:user] = newUser
  end  
end

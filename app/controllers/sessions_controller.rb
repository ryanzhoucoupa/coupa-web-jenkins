class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      redirect_to users_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    User.current_user = nil
    redirect_to root_path
  end
end
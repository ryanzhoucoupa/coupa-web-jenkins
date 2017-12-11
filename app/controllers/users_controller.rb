class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :destroy]
  protect_from_forgery :except => [:create, :ept, :unregister]
#  before_action :authenticate_user!, :except => [:create, :ept, :unregister]

  HEROKU_DOMAIN = 'https://fierce-meadow-67656.herokuapp.com'

  # GET /users
  # GET /users.json
  def index
    flash[:notice] = params.fetch(:message, '')
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def qr
    @user = User.find_by(id: params[:id])

    if @user.github_login
      @qrcode = RQRCode::QRCode.new("#{HEROKU_DOMAIN}/ept.json?ghUser=#{@user.github_login}")
    end
  end

  # POST /users
  # POST /users.json
  def create
    user_params = params.slice(:github_login, :expo_push_token)
    @user = User.find_or_create_by(github_login: user_params[:github_login])
    @user.expo_push_token = user_params[:expo_push_token]

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
=begin
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  #for updating expo push token
  def ept
    github_login = params.delete(:github_login)
    user_params = params.slice(:expo_push_token)
    user_params[:active] = true

    @user = User.find_by(github_login: github_login)

    if @user.update(user_params)
      link = Rails.env.production? ? HEROKU_DOMAIN : "http://localhost:3000"
      link += "/users?message=Activated"

      #need to setup redis on heroku
      # heroku addons:add redistogo
      #$ heroku config --app action-cable-example | grep REDISTOGO_URL
      #REDISTOGO_URL:            redis://redistogo:d0ed635634356d4408c1effb00bc9493@hoki.redistogo.com:9247/
      # config/cable.yml
      # https://blog.heroku.com/real_time_rails_implementing_websockets_in_rails_5_with_action_cable
      ActionCable.server.broadcast 'messages', link: link
      render json: {}, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def action_cable
    link = Rails.env.production? ? HEROKU_DOMAIN : "http://localhost:3000"
    link += "/users?message=Activated"
    head :ok
  end

  def unregister
    github_login = params.delete(:github_login)

    user = User.find_by(github_login: github_login)

    if user.update(expo_push_token: nil, active: false)
      head :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def user_params
    #  params.fetch(:user, {})
    #end
end

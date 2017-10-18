class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:create]
  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all.order(:id)
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.find_by(id: params[:id])
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications
  # POST /notifications.json
  def create
=begin
    "ci/jenkins-unit" => {
      "context" => "ci/jenkins-unit"
      "status" => "pending",
      "comment" => "asdfasdf",
      "url" => "asdf",
      "ghprbPullId" => '123123'

    }
=end

    notification_params = params.slice(:to, :title, :body).merge(data: params[:data].to_json)
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def deliver
    id = params.fetch(:id, nil)
    notification = Notification.find_by(id: id)

    if notification
      messages = [{
        to: notification.to,
        title: notification.title,
        body: notification.body,
        data: JSON.parse(notification.data)
      }]

      resp = HTTParty.post('https://exp.host/--/api/v2/push/send',
        body: messages.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip, deflate'
        }
      )

      flash[:notice] = 'Delivered'
    else
      flash[:error] = 'Notification not found'
    end

    redirect_to notifications_path
  end

  def list
    push_token = params.fetch(:pt, nil)

    if push_token
      notifications = Notification.select(:data).where(to: push_token).order(:id)
    end

    render json: notifications
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
#  def update
#    respond_to do |format|
#      if @notification.update(notification_params)
#        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
#        format.json { render :show, status: :ok, location: @notification }
#      else
#        format.html { render :edit }
#        format.json { render json: @notification.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
#    def notification_params
#      params.fetch(:notification, {})
#    end
end

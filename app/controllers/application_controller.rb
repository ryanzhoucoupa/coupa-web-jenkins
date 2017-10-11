class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  ActionController::Parameters.permit_all_parameters = true
end

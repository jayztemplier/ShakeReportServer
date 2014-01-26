class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      if ENV['SR_USERNAME'] && ENV['SR_PASSWORD']
        username == ENV['SR_USERNAME'] && password == ENV['SR_PASSWORD']
      else
        true 
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end

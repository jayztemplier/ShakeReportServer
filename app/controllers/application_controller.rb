class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    if ENV['SR_USERNAME'] && ENV['SR_PASSWORD']
  #      username == ENV['SR_USERNAME'] && password == ENV['SR_PASSWORD']
  #    else
  #      true
  #    end
  #  end
  #end

  def ensure_application
    redirect_to root_url, alert: "Application not found" unless current_application
  end
  protected
  def require_login
    if current_user
      true
    else
      redirect_to authentication_url
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_application
    current_user.applications.find(params[:application_id]) if params[:application_id] && current_user.application_ids.include?(params[:application_id])
  end
  helper_method :current_application

end

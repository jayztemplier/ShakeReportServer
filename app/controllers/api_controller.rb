class ApiController < ActionController::Base
  protect_from_forgery
  before_filter :require_application

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    if ENV['SR_USERNAME'] && ENV['SR_PASSWORD']
  #      username == ENV['SR_USERNAME'] && password == ENV['SR_PASSWORD']
  #    else
  #      true
  #    end
  #  end
  #end

  protected
  def require_application
    if current_application
      true
    else
      # render 401
    end
  end

  private

  def current_application
    @current_application ||= Application.find_by(token: application_id) if application_id
  end
  helper_method :current_application

  def application_id
    request.headers['X-APPLICATION-TOKEN'] || params[:token]
  end

end

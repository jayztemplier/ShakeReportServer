class SessionsController < ApplicationController
  skip_before_filter :require_login

  def index
    if current_user
      # redirect to root
    else
      # render the login page
    end
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

end
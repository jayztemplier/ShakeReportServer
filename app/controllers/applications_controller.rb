class ApplicationsController < ApplicationController

  def index
    @applications = current_user.applications
  end

  def create
    if current_user.is_super_admin
      application = Application.new(params[:application])
      if application.save
        current_user.application_ids << application.id
        current_user.save
        redirect_to :back, notice: "Application created!"
      else
        redirect_to :back, alert: "An error occurred during the creation of the application"
      end
    else
      redirect_to :back, alert: "You can't create an application with this user."
    end
  end
end

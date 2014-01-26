class ApplicationsController < ApplicationController

  def index
    @applications = current_user.applications
  end

  def create
    application = Application.new(params[:application])
    if application.save
      current_user.application_ids << application.id
      current_user.save
      redirect_to :back, notice: "Application created!"
    else
      redirect_to :back, alert: "An error occurred during the creation of the application"
    end
  end
end

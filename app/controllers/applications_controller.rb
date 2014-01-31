class ApplicationsController < ApplicationController


  def index
    @applications = current_user.applications
  end

  def create
    if current_user.can_create_application?
      application = Application.new(params[:application])
      if application.save
        ApplicationAccess.create!(application_id: application.id, user_id: current_user.id, role: ApplicationAccess::ROLE[:admin])
        redirect_to :back, notice: "Application created!"
      else
        redirect_to :back, alert: "An error occurred during the creation of the application"
      end
    else
      redirect_to :back, alert: "You can't create an application with this user."
    end
  end
end

class InvitationsController < ApplicationController

  # GET /invitations
  # GET /invitations.json
  def index
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      invitation.use!(current_user)
      application = invitation.application
      invitation.delete
      redirect_to root_url, notice: "You now have access to #{application.name}."
    else
      redirect_to root_url, alert: "Invitation not valid."
    end
  rescue
    redirect_to root_url, alert: "Invitation not valid."
  end
end

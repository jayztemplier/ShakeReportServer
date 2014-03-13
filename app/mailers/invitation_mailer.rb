class InvitationMailer < ActionMailer::Base
  default from: "no-reply@shakereport.com"

  def new_invitation(invitation, token)
    @invitation = invitation
    @token = token
    mail(bcc: invitation.email, subject: "[ShakeReport] Invitation for #{@invitation.application.name}")
  end
end

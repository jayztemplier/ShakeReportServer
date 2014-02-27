class BuildMailer < ActionMailer::Base
  default from: "no-reply@shakereport.com"

  def new_build_available(emails, build)
    @build = build
    mail(bcc: emails, subject: "[ShakeReport] Build available for #{@build.application.name}")
  end
end

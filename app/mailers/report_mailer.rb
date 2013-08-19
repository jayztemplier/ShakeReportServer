class ReportMailer < ActionMailer::Base
  default from: "no-reply@shakereport.com"
  
  def daily_summary(emails, reports)
    @reports = reports
    @date_string = Date.today.to_formatted_s(:long)
    mail(bcc: emails, subject: "[ShakeReport] Daily report - #{@date_string}")
  end
end

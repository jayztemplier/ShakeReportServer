class ReportMailer < ActionMailer::Base
  default from: "no-reply@shakereport.com"
  
  def daily_summary(emails, reports)
    @reports = reports
    @date_string = Date.today.to_formatted_s(:long)
    mail(to: "no-reply@shakereport.com" ,bcc: emails, subject: "[ShakeReport] Daily report - #{@date_string}")
  end
end

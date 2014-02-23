class ReportMailer < ActionMailer::Base
  default from: "no-reply@shakereport.com"

  def new_report_created(emails, report)
    @report = report
    mail(bcc: emails, subject: "[ShakeReport] New Report: #{@report.title}")
  end

  def daily_summary(emails, reports)
    puts "send #{reports.count} reports to #{emails}"
    @reports = reports
    @date_string = Date.today.to_formatted_s(:long)
    mail(bcc: emails, subject: "[ShakeReport] Daily report - #{@date_string}")
  end
end

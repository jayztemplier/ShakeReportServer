class AlertMail
  include Mongoid::Document
  
  field :email, type: String

  
  def self.send_daily_summary
    applications = Application.all
    applications.each do |app|
      emails = []
      app.users.each { |u| emails << u.email unless u.email.nil?}
      reports = app.reports.today
      ReportMailer.daily_summary(emails, reports).deliver if !emails.empty? && !reports.empty?
    end
  end
end

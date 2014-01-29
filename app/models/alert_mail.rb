class AlertMail
  include Mongoid::Document
  
  field :email, type: String

  
  def self.send_daily_summary
    applications = Application.all
    applications.each do |app|
      emails = []
      app.users.each { |u| emails << u.email unless u.email.nil?}
      ReportMailer.daily_summary(emails, app.reports.today).deliver unless emails.empty?
    end
  end
end

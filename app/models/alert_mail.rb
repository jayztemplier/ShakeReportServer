class AlertMail
  include Mongoid::Document
  
  field :email, type: String

  
  def self.send_daily_summary
    applications = Application.all
    applications.each do |app|
      emails = app.users.map(&:email)
      ReportMailer.daily_summary(emails, app.reports.today).deliver
    end

  end
end

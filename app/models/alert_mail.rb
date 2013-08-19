class AlertMail
  include Mongoid::Document
  
  field :email, type: String
  
  def self.send_daily_summary
    mails = AlertMail.all
    email = mails.map(&:email)
    reports = Report.today
    ReportMailer.daily_summary(email, reports).deliver
  end
end

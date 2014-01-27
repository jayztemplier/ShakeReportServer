class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Commentable
  

  default_scope order_by(:created_at => :desc)
  
  STATUS = {new: 0, available_on_next_build: 1 ,ready_to_test: 2, archived: 3}
  field :title, type: String
  field :message, type: String
  field :device_model, type: String
  field :os_version, type: String
  field :screenshot, type: String
  field :logs, type: String
  field :crash_logs, type: String
  field :dumped_view, type: String
  field :status, type: Integer, default: STATUS[:new]
  field :jira_ticket, type: String

  field :fix_version, type: String

  embedded_in :application, inverse_of: :reports

  has_mongoid_attached_file :screen_capture
  
  validate :has_one_attribute_set
  
  scope :opened, where(:status => STATUS[:new])
  scope :available_on_next_build, where(:status => STATUS[:available_on_next_build])
  scope :ready_to_test, where(:status => STATUS[:ready_to_test])
  scope :archived, where(:status => STATUS[:archived])
  scope :today, where(:created_at.gte => Date.today)

  def message_for_ticket
    host = Rails.application.config.action_mailer.default_url_options[:host]
    m = "--------------------------------------------------------------\n"
    m = m + "OS: #{self.os_version}\n"
    m = m + "Device: #{self.device_model}\n"
    m = m + "--------------------------------------------------------------\n"
    m = m + message + "\n"
    m = m + "--------------------------------------------------------------\n"
    m = m + "Video: #{self.screen_capture.url}\n" if self.screen_capture_file_name
    m = m + "More info there: #{Rails.application.routes.url_helpers.report_url(self, host: host)}\n"
    m = m + "Created with Shake Report."
  end
  
  protected
  def has_one_attribute_set
    if title.nil? && message.nil? && device_model.nil? && os_version.nil? && screenshot.nil? && logs.nil? && crash_logs.nil? && dumped_view.nil?
      errors.add(:title, 'or at least one attribute needs to be set')
    end
  end
end

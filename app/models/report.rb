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

  field :fix_version, type: String
  
  has_mongoid_attached_file :screen_capture
  
  scope :opened, where(:status => STATUS[:new])
  scope :available_on_next_build, where(:status => STATUS[:available_on_next_build])
  scope :ready_to_test, where(:status => STATUS[:ready_to_test])
  scope :archived, where(:status => STATUS[:archived])
  scope :today, where(:created_at.gte => Date.today)

end

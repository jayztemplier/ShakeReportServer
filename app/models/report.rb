class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  
  default_scope order_by(:created_at => :desc)
  
  STATUS = {new: 0, archived: 1}
  field :screenshot, type: String
  field :logs, type: String
  field :crash_logs, type: String
  field :dumped_view, type: String
  field :status, type: Integer, default: STATUS[:new]

  scope :opened, where(:status => STATUS[:new])
  scope :archived, where(:status => STATUS[:archived])
end

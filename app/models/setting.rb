class Setting
  include Mongoid::Document
  
  field :values, type: Hash

  embedded_in :application
  
  def set(key, value)
    values = {} if values.nil?
    values[key.to_s] = value
  end
  
  def get(key)
    values.nil? ? nil : values[key.to_s]
  end
  
  def jira_valid?
    client = Jira::Client.default_client
    project_key = get(:jira_project_key)
    issue_id = get(:jira_issue_id)
    return client && project_key && issue_id && client.connected?
  end
  
  private
  def self.create_settings
    Setting.create!(values: {})
  end
end

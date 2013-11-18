class SettingsController < ApplicationController

  before_filter :authenticate, :init_variables
  
  # GET /settings
  # GET /settings.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @settings }
    end
  end

  def update_jira
    project_key = params[:project]
    issue_id = params["issue_#{project_key}"]
    @settings.set(:jira_project_key, project_key)
    @settings.set(:jira_issue_id, issue_id)
    respond_to do |format|
      if @settings.save
        format.html { redirect_to settings_url, notice: 'Settings was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @settings.errors, status: :unprocessable_entity }
      end
    end
  end
  
  protected
  def init_variables
    @settings = Setting.get_settings
    get_jira_project
  end
  
  def get_jira_project
    @jira_project_key = @settings.get(:jira_project_key)
    @jira_issue_id = @settings.get(:jira_issue_id)
    @jira_projects = $jira_client.projects
  end
end

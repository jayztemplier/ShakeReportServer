class SettingsController < ApplicationController

  before_filter :ensure_application
  before_filter :init_variables
  
  # GET /settings
  # GET /settings.json
  def index
    @accesses = current_application.accesses if current_user.is_admin?(current_application)
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

  def add_user

    user = User.where(name: params[:application_access][:username]).exists? ? User.find_by(name: params[:application_access][:username]) : nil
    respond_to do |format|
      if !user.nil? && ApplicationAccess.create(application_id: current_application.id, user_id: user.id).errors.empty?
        format.html { redirect_to application_settings_url(current_application), notice: "User '#{user.name}' added to #{current_application.name}." }
        format.json { head :no_content }
      else
        format.html { redirect_to application_settings_url(current_application), alert: "An error occured while adding '#{params[:application_access][:username]}' to #{current_application.name}." }
        format.json { head :no_content, status: :unprocessable_entity }
      end
    end
  end

  protected
  def init_variables
    @settings = current_application.setting
    get_jira_project
  end
  
  def get_jira_project
    @jira_project_key = @settings.get(:jira_project_key)
    @jira_issue_id = @settings.get(:jira_issue_id)
    @jira_projects = $jira_client.projects if $jira_client
  end
end

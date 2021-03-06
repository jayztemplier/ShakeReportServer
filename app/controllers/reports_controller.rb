class ReportsController < ApplicationController

  before_filter :ensure_application

  # GET /reports
  # GET /reports.json
  def index
    @status = params[:scope] ? params[:scope].to_sym : :new
    if @status == :archived
      @reports = current_application.reports.archived
    elsif @status == :available_on_next_build
      @reports = current_application.reports.available_on_next_build
    elsif @status == :ready_to_test
      @reports = current_application.reports.ready_to_test
    else
      @status = :new
      @reports = current_application.reports.opened
    end
    puts "status: #{@status}"
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = current_application.reports.find(params[:id])
    @show_jira = current_application.setting.jira_valid?
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # PUT /reports/1/update_status
  # PUT /reports/1/update_status.json
  def update_status
    @report = current_application.reports.find(params[:report_id])
    new_status = @report.status+1 < Report::STATUS.size ? @report.status+1 : @report.status
    
    respond_to do |format|
      if new_status != @report.status && @report.update_attributes(status: new_status)
        format.html { redirect_to application_report_url(@report.application, @report), notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        @show_jira = Setting.get_settings.jira_valid?
        format.html { render action: "show", notice: "The current status is the last level of report status available." }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/new_build
  # PUT /reports/new_build.json
  def new_build
    attributes = {status: Report::STATUS[:ready_to_test]}
    attributes[:fix_version] = params[:version] if params[:version]
    @reports = current_application.reports.available_on_next_build
    @count = @reports.count
    @reports.update_all(attributes) if @count > 0
    respond_to do |format|
      if @count > 0 && @reports
        format.html { redirect_to reports_url, notice: "New build created, #{@count} reports updated." }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'New build annouced, but not report was waiting for a new build.' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_jira_issue
    @report = current_application.reports.find(params[:report_id])
    settings = current_application.setting
    client = Jira::Client.default_client
    respond_to do |format|
      if client
        begin
          @jira_url = Jira::Client.default_client.create_issue_for_report(@report, settings.get(:jira_project_key), settings.get(:jira_issue_id))
          if @report.update_attributes({jira_ticket: @jira_url}) && @report.jira_ticket == @jira_url
            format.html { redirect_to application_report_url(current_application, @report), notice: "Jira issue successfully created: #{@jira_url}"}
            format.json { render json: @report, status: :created }
          else
            message = "An error occured during the linking of the report with the Jira ticket: #{@jira_url}"
            format.html { redirect_to application_report_url(current_application, @report), alert: message }
            format.json { render json: {error: message}, status: :unprocessable_entity }
          end
        rescue Jira::Error::NotConnectedError
          message = 'An error occured, Jira issue not created. Please check that you configuration is correct.'
          format.html { redirect_to application_report_url(current_application, @report), alert: message }
          format.json { render json: {error: message}, status: :unprocessable_entity }
        rescue Exception => e   
          message = "An error occured. #{e}"
          format.html { redirect_to application_report_url(current_application, @report), alert: message }
          format.json { render json: {error: message}, status: :unprocessable_entity }          
        end
      else  
        message = 'Jira not configured.'
        format.html { redirect_to application_report_url(current_application, @report), alert: message }
        format.json { render json: {error: message}, status: :method_not_allowed }
      end
    end
  end
end

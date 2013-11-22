class ReportsController < ApplicationController

  before_filter :authenticate
  
  # GET /reports
  # GET /reports.json
  def index
    @status = params[:scope] ? params[:scope].to_sym : :open
    if @status == :archived
      @reports = Report.archived
    elsif @status == :available_on_next_build
      @reports = Report.available_on_next_build
    elsif @status == :ready_to_test
      @reports = Report.ready_to_test
    else
      @status = :new
      @reports = Report.opened
    end
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
    @show_jira = Setting.get_settings.jira_valid?
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    respond_to do |format|
      if @report.save
        format.json { render json: @report, status: :created, location: @report }
      else
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1/update_status
  # PUT /reports/1/update_status.json
  def update_status
    @report = Report.find(params[:report_id])
    new_status = @report.status+1 < Report::STATUS.size ? @report.status+1 : @report.status
    
    respond_to do |format|
      if new_status != @report.status && @report.update_attributes(status: new_status)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
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
    @reports = Report.available_on_next_build
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
    @report = Report.find(params[:report_id])
    settings = Setting.get_settings
    @jira_url = Jira::Client.default_client.create_issue_for_report(@report, settings.get(:jira_project_key), settings.get(:jira_issue_id))
    respond_to do |format|
      if @jira_url && @report.update_attributes({jira_ticket: @jira_url})
        format.html { redirect_to @report, notice: "Jira issue successfully created: #{@jira_url}"}
        format.json { render json: {jira_issue_url: @jira_url}, status: :created }
      else
        format.html { redirect_to @report, alert: 'Jira issue not created.' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end
end

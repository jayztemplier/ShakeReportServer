class Api::ReportsController < ApiController

  # POST api/reports
  # POST api/reports.json
  def create
    @report = current_application.reports.new(params[:report])
    if @report.save
      render json: @report, status: :created
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

end

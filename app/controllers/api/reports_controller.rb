class ReportsController < ApiController

  # POST api/reports
  # POST api/reports.json
  def create
    @report = current_application.reports.new(params[:report])
    respond_to do |format|
      if @report.save
        format.json { render json: @report, status: :created, location: @report }
      else
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

end

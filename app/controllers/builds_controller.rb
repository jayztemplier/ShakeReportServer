class BuildsController < ApplicationController

  before_filter :ensure_application

  # GET /builds
  # GET /builds.json
  def index
    @builds = current_application.builds
    @build = current_application.builds.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @builds }
    end
  end

  def create
    @build = current_application.builds.new(params[:build])
    if @build.save
      redirect_to application_builds_url(current_application), notice: "Build uploaded!"
    else
      @builds = current_application.builds
      render action: :index, alert: "An error occured, build not uploaded."
    end
  end
end

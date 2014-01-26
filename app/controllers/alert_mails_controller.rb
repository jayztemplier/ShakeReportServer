class AlertMailsController < ApplicationController

  before_filter :ensure_application

  # GET /mails
  # GET /mails.json
  def index
    @mails = AlertMail.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mails }
    end
  end

  # POST /mails
  # POST /mails.json
  def create
    @mail = AlertMail.new(params[:alert_mail])

    respond_to do |format|
      if @mail.save
        format.html { redirect_to alert_mails_url, notice: 'New email added with success.' }
        format.json { render json: @mail, status: :created, location: @mail }
      else
        @mails = AlertMail.all
        format.html { render action: "index" }
        format.json { render json: @mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mails/1
  # DELETE /mails/1.json
  def destroy
    @mail = AlertMail.find(params[:id])
    @mail.destroy

    respond_to do |format|
      format.html { redirect_to alert_mails_url }
      format.json { head :no_content }
    end
  end
  
end

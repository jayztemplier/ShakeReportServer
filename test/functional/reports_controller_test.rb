require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  
  setup do
    Report.delete_all
  end
  
  context "when the user is not authenticated" do
    setup do  
      @report = FactoryGirl.create(:report)
    end
    should "not have access to the index page" do
      get :index
      assert_response :unauthorized
    end
    should "not have access to the show page" do
      get :show, id: @report.id
      assert_response :unauthorized
    end
    should "not have access to the creation method" do
      post :create, report: {title: "title for report"}
      assert_response :unauthorized
    end
    should "not have access to the create jira ticket method" do
      post :create_jira_issue, report_id: @report.id
      assert_response :unauthorized
    end
  end
  
  context "when the user is authenticated" do
    setup do
      http_login
    end
    
    context "when requesting new reports" do
      setup do
        @report = FactoryGirl.create(:report)
        get :index
      end
      should "be a success" do
        assert_response :success
      end
      should "get one report" do
        reports = assigns(:reports)
        assert_equal 1, reports.size
      end
    end

    context "when requesting archived reports" do
      setup do
        FactoryGirl.create(:report, status: Report::STATUS[:new])
        FactoryGirl.create(:report, status: Report::STATUS[:available_on_next_build])    
        get :index, scope: :archived
      end
      
      context "but there is no archived report" do
        should "be a success" do
          assert_response :success
        end
        should "get zero report" do
          reports = assigns(:reports)
          assert_equal 0, reports.size
        end
      end
      
      context "and two of all the reports are archived" do
        setup do
          2.times {FactoryGirl.create(:report, status: Report::STATUS[:archived])}
        end
        should "be a success" do
          assert_response :success
        end
        should "get zero report" do
          reports = assigns(:reports)
          assert_equal 2, reports.size
        end
      end
    end
    
    context "and ask for the show view of a report" do
      setup do
        @report = FactoryGirl.create(:report)
        get :show, id: @report.id        
      end
      should "have a success" do
        assert_response :success
      end
      should "see the right report" do
        report = assigns(:report)
        assert_equal @report.id, report.id
      end
    end
    
    context "and want to update the status of the report" do
      setup do
        @report = FactoryGirl.create(:report)
      end
      context "and the current status has a next step" do
        setup do
          put :update_status, report_id: @report.id
        end
        should "get a redirect" do
          assert_response :found
        end
        should "update the status by 1" do
          assert_equal @report.status+1, Report.find(@report.id).status
        end
      end
      context "and the current status is the last status available" do
        setup do
          @report.update_attributes(status: Report::STATUS[:archived])
          put :update_status, report_id: @report.id
        end
        should "get a redirect" do
          assert_response :success
        end
        should "not update the report" do
          assert_equal @report.status, Report.find(@report.id).status
        end
      end
    end
    
    context "and try to create a report through the JSON API" do
      context "and provide a good set of params" do
        setup do
          @report_params = {
            title: "a title",
            message: "a message",
            logs: "some logs",
            crash_logs: "some crash logs"
          }
          post :create, report: @report_params, format: :json
        end
        should "get a created response" do
          assert_response :created
        end
        should "get back a JSON representation of the report" do
          report = JSON.parse @response.body
          assert_not_nil report
          assert_equal @report_params[:title], report['title']
          assert_equal @report_params[:message], report['message']
          assert_equal @report_params[:logs], report['logs']
          assert_equal @report_params[:crash_logs], report['crash_logs']
        end
      end
    end
    
  end
  
  def http_login
    user = ENV['SR_USERNAME']
    pw = ENV['SR_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end

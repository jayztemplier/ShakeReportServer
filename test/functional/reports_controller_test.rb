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
    should "not have access to the new report page" do
      get :new
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
  end
  
  def http_login
    user = ENV['SR_USERNAME']
    pw = ENV['SR_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end

require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  
  setup do
    Report.delete_all
    @report = FactoryGirl.create(:report)
  end
  
  context "when requesting index" do
    setup do
      user = ENV['SR_USERNAME']
      pw = ENV['SR_PASSWORD']
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
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
end

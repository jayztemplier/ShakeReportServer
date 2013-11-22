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
    
    context "when requesting reports" do
      Report::STATUS.keys.each do |status|
        context "for status #{status}" do
          setup do
            @report = FactoryGirl.create(:report, status: Report::STATUS[status])
            get :index, scope: status
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
      context "and an no param is provided" do
        setup do
          post :create, report: {}, format: :json
        end
        should "get an unprocessable entity response" do
          assert_response :unprocessable_entity
        end
      end
    end
    
    context "and declare a new build is available" do
      setup do
        @version = "1.0"
        @request.env['HTTP_REFERER'] = 'http://example.com/'
      end
      context "and we have at least one report waiting for a new build" do
        setup do
          FactoryGirl.create(:report, status: Report::STATUS[:available_on_next_build])
        end
        should "get a redirection" do
          put :new_build, version: @version
          assert_response :found
        end
        should "get a notice message" do
          put :new_build, version: @version
          assert_not_nil flash[:notice]
        end
        should "add a new report ready to be tested" do
          assert_difference 'Report.ready_to_test.count' do
            put :new_build, version: @version
          end
        end
      end
      context "and no report is waiting for a new build to be tested" do
        setup do
          assert_equal 0, Report.available_on_next_build.count
        end
        should "get a redirection" do
          put :new_build, version: @version
          assert_response :found
        end
        should "get a alert message" do
          put :new_build, version: @version
          assert_not_nil flash[:alert]
        end
        should "not have a new report ready for tests" do
          assert_no_difference 'Report.ready_to_test.count' do
            put :new_build, version: @version
          end
        end
        should "have a count set to zero" do
          put :new_build, version: @version
          assert_equal 0, assigns(:count)
        end
      end
    end
    context "and wants to create a jira ticket for a report" do
      setup do
        @report = FactoryGirl.create(:report)
      end
      context "but jira isn't configured" do
        setup do
          Jira::Client.stubs(:default_client).returns(nil)
          post :create_jira_issue, report_id: @report.id
        end
        should "get an alert message" do
          assert_not_nil flash[:alert]
        end
        should "get a redirect" do
          assert_response :found
        end
      end
      context ", jira is configured" do
        setup do
          Jira::Client.stubs(:default_client).returns(Jira::Client.new("http://example.com", "myusername", "mypassword"))
        end
        context "but the jira instance is not reachable (host, username, or password issue)" do
          setup do
            Jira::Client.any_instance.stubs(:status).returns(403)
            post :create_jira_issue, report_id: @report.id
          end
          should "get an alert message" do
            assert_not_nil flash[:alert]
          end
          should "get a redirect" do
            assert_response :found
          end
        end
        context "and the jira client is connected" do
          setup do
            Jira::Client.any_instance.stubs(:status).returns(200)
            Setting.any_instance.stubs(:get).returns("aValue")
          end
          context "but Jira returned and error during the creation of the ticket" do
            setup do
              stub_request(:post, "http://myusername:mypassword@example.com/rest/api/2/issue/").to_return(:status => [401, "Forbidden"])
              post :create_jira_issue, report_id: @report.id
            end
            should "get an alert message" do
              assert_not_nil flash[:alert]
            end
            should "get a redirect" do
              assert_response :found
            end
          end
          context "and jira successfuly created the issue" do
            setup do
              Jira::Client.any_instance.stubs(:post_request).returns("www.jiraticket.com")
            end
            context "and the report saved the jira ticket url" do
              setup do
                post :create_jira_issue, report_id: @report.id
              end
              should "get an notice message" do
                assert_not_nil flash[:notice]
              end
              should "get a redirect" do
                assert_response :found
              end
            end
            context "but the report didn't update the jira ticket url" do
              setup do
                Report.any_instance.stubs(:jira_ticket).returns(nil)
                post :create_jira_issue, report_id: @report.id
              end
              should "get an alert message" do
                assert_not_nil flash[:alert]
              end
              should "get a redirect" do
                assert_response :found
              end
            end
          end
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

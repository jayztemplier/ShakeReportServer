module Jira
  class Client
    include HTTParty
    default_timeout 20
    
    API_SUFFIX = 'rest/api/2'
    
    Project = Struct.new(:name, :key, :issue_types)
    IssueType = Struct.new(:name, :id)
    
    def self.default_client
      $jira_client
    end
    
    def self.enabled?
      !$jira_client.nil?
    end
    
    def initialize(endpoint, username, password)
      endpoint  = File.join(endpoint, API_SUFFIX)
      @base_uri = endpoint
      @auth = {:username => username, :password => password}
    end
    
    def host
      @host ||= base_options[:base_uri].gsub(/\/rest\/api\/2$/, '')
    end
    
    def user
      @auth[:username]
    end
    
    def connected?
      status == 200
    end

    def status
      @connection_status ||=
        begin
          self.class.get('/serverInfo', {base_uri: @base_uri, basic_auth: @auth}).code
        rescue Errno::ECONNREFUSED, Timeout::Error, HTTParty::UnsupportedURIScheme, SocketError, URI::InvalidURIError
          0 # other issue
        end
    end
    
    def assert_connected
      raise Jira::Error::AuthenticationError.new("Status is #{connection_status}") unless connected?
    end
    
    def base_options
      @base_options ||= {base_uri: @base_uri, basic_auth: @auth}
    end
    
    def create_meta
      self.class.get('/issue/createmeta', base_options).parsed_response
    end
    
    def projects
      assert_connected
      projects = self.create_meta['projects']
      projects.collect do |pr|
        Project.new(pr['name'], pr['key'], pr['issuetypes'].collect{|type| IssueType.new(type['name'], type['id'])} )
      end
    end
    
    def find_project(key)
      assert_connected
      response = self.class.get("/project/#{key}", base_options)

      if response.code == 200
        Project.new(response.parsed_response['name'],response.parsed_response['key'],response.parsed_response['issueTypes'].collect{ |type| IssueType.new(type['name'], type['id']) })
      else
        raise Jira::Error::NoSuchProjectError
      end
    end
    
    def create_issue_for_report(report, project_key, issue_type_id)
      message = report.message_for_ticket
      create_issue(project_key, issue_type_id, report.title, message)
    end
    
    def create_issue(project_key, issue_type_id, summary, description)
      body =
        { 'fields' =>
          {
            'project' => {'key' => project_key},
            'issuetype' => {'id' => issue_type_id},
            'summary' => summary,
            'description' => description
          }
        }
      response = post_request('/issue/', {body: body.to_json, headers: {'Content-Type' => 'application/json'}})
    end
    
    def post_request(path, options = {})
      resp = self.class.post('/issue/', base_options.merge(options))
      if resp.code == 201
        jira_root = self.host
        return "#{jira_root}/browse/#{resp.parsed_response['key']}"
      else
        error = Jira::Error.build_error(resp.body)
        raise error
      end
    end
    
  end
end
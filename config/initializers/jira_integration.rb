# run jira local instance:  atlas-run-standalone --product jira
# JIRA_HOST='http://MacBook-Pro-de-jeremy.local:2990/jira' JIRA_USERNAME=admin JIRA_PASSWORD="admin" rails c
jira_host = ENV['JIRA_HOST']      # 'http://MacBook-Pro-de-jeremy.local:2990/jira'
username =  ENV['JIRA_USERNAME']  # jeremy
password =  ENV['JIRA_PASSWORD']  # mypassword

if jira_host and username and password
  $jira_client = Jira::Client.new(jira_host, username, password)
  puts "Connection to Jira: #{$jira_client.status}"
end

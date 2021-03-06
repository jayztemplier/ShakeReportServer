namespace :heroku do
  desc "Setup heroku application"
  task :setup, [:app] => [:environment] do |t, args|
    app = args[:app]
    puts "---------------SR REPORT -----------------"
    system "heroku addons:add mongohq --app #{app}"
    system "heroku addons:add scheduler --app #{app}"
    system "heroku addons:add sendgrid:starter --app #{app}"
    puts "---------------- DONE -------------------"
  end
  
  desc "Setup AWS3"
  task :setup_aws, [:app, :bucket, :key, :secret_key] => [:environment] do |t, args|
    app = args[:app]
    remote = "git@heroku.com:#{app}.git"
    puts "---------------SR REPORT -----------------"
    puts "Setting up AWS3 on #{app} ... "
    system "heroku config:set AWS_BUCKET=#{args[:bucket]} --app #{app}"
    system "heroku config:set AWS_ACCESS_KEY_ID=#{args[:key]} --app #{app}"
    system "heroku config:set AWS_SECRET_ACCESS_KEY=#{args[:secret_key]} --app #{app}"
    puts "---------------- DONE -------------------"
  end
  
  desc "Setup Jira integration"
  task :setup_jira, [:host, :username, :password] => [:environment] do |t, args|
    app = args[:app]
    remote = "git@heroku.com:#{app}.git"
    puts "---------------SR REPORT -----------------"
    puts "Setting up JIRA integration on #{app} ... "
    system "heroku config:set JIRA_HOST=#{args[:host]} --app #{app}"
    system "heroku config:set JIRA_USERNAME=#{args[:username]} --app #{app}"
    system "heroku config:set JIRA_PASSWORD=#{args[:password]} --app #{app}"
    puts "---------------- DONE -------------------"
  end
  
  desc "Deploy current branch"
  task :deploy, [:app] => [:environment] do |t, args|
    app = args[:app]
    remote = "git@heroku.com:#{app}.git"
    puts "---------------SR REPORT -----------------"
    puts "Deploying #{app} ... "
    system "heroku maintenance:on --app #{app}"
    system "git push #{remote} master"
    system "heroku maintenance:off --app #{app}"
    puts "---------------- DONE -------------------"
  end
end

namespace :local do
  desc "Setup local application"
  task :setup, [:username, :password] => [:environment] do |t, args|
    puts "---------------SR REPORT -----------------"    
    puts "Setting up local app with username #{args[:username]}"
    system "export SR_USERNAME=#{args[:username]}"
    system "export SR_PASSWORD=#{args[:password]}"
    puts "---------------- DONE -------------------"
  end
  
  desc "Setup AWS3"
  task :setup_aws, [:bucket, :key, :secret_key] => [:environment] do |t, args|
    puts "---------------SR REPORT -----------------"
    puts "Setting up AWS3 locally ..."
    system "export AWS_BUCKET=#{args[:bucket]}"
    system "export AWS_ACCESS_KEY_ID=#{args[:key]}"
    system "export AWS_SECRET_ACCESS_KEY=#{args[:secret_key]}"
    puts "---------------- DONE -------------------"
  end
  
  
  desc "Setup Jira integration"
  task :setup_jira, [:host, :username, :password] => [:environment] do |t, args|
    app = args[:app]
    puts "---------------SR REPORT -----------------"
    puts "Setting up JIRA integration locally ..."
    system "export JIRA_HOST=#{args[:host]}"
    system "export JIRA_USERNAME=#{args[:username]}"
    system "export JIRA_PASSWORD=#{args[:password]}"
    puts "---------------- DONE -------------------"
  end
end
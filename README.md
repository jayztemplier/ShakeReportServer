# Shake Report Server [![Build Status](https://travis-ci.org/jayztemplier/ShakeReportServer.png)](https://travis-ci.org/jayztemplier/ShakeReportServer)


Shake Report server is a small server that you can use as a backend for the Shake Report iOS library
https://github.com/jayztemplier/ShakeReport

The Shake Reporter backend has been written in Ruby, using Ruby on Rails. By default, it uses Sendgrid (for the production environment). Originally, it's been written to be super easy to install on Heroku. The installation process explains how to deploy your own instance of the backend on Heroku.

<a href="http://shakereport.com/">Go to our website to get more information</a>


#Shake Report?
Shake Reporter is a framework that allows you to easily get bug reports from users of your mobile application. When you see something wrong, shake the device, and report the issue with a custom message. You can either receive reports by email or configure a shake report backend which will collect and classify the reports.


# Features
* Support of multiple application
* Authentication with Github
* Roles: admin, user, super admin
* List of the reports sent from the devices
* Possibility to archive the report
* Support Jira integration -- in progress
* Save video recording on AWS3
* Distribution of iOS Over Tthe Air

 
# Requirement

* MongoDB
* Ruby 1.9.3

# Installation

Clone the repository:
`git clone git@github.com:jayztemplier/ShakeReportServer.git`

Enter in the ShakeReportServer folder:
`cd ShakeReportServer`

Make sure you have all the dependencies by running:
`./script/install_dependencies.sh`

Run the bundle command:
`bundle install`

Set up a user:
`bundle exec rake local:setup[jeremy,mypassword]`

If you don't setup a user, by default the website won't be protected.

Launch the rails app:
`rails s`	

# Deploy on Heroku
Create an Heroku app:
`heroku create my_app_name`

Enable SendGrid, Scheduler and MongoHQ for your heroku app
`bundle exec rake heroku:setup[my_app_name,jeremy,mypassword]`

Deploy!
`bundle exec rake heroku:deploy[my_app_name]`

Check that it's running by visiting `http://localhost:3000`
A prompt will ask you your username and password. Use the logins you just created.

# Use AWS3 storage
## Local
Simply run this command:
`bundle exec rake local:setup_aws[bucket_name,key,secret_key]`
## Heroku
Almost the same command:
`bundle exec rake heroku:setup_aws[bucket_name,key,secret_key]`


# Activate Jira integration (Work still in progress.)

## Local
Setup your environement with some Jira information:
`bundle exec rake local:setup_jira[url_to_jira,username,password]`

Then lunch the server and go to your settings page to make sure a project and an issue type are defined.
To report a new ticket, open a report and clic on «Create a Jira ticket »
## Heroku
Same thing than locally, but run this command line instead :
`bundle exec rake heroku:setup_jira[url_to_jira,username,password]`

# License
SRReport is available under the MIT license. See the LICENSE file for more info

# Shake Report Server

Shake Report server is a small server that you can use as a backend for the Shake Report iOS library
https://github.com/jayztemplier/ShakeReport

The Shake Reporter backend has been written in Ruby, using Ruby on Rails. By default, it uses Sendgrid (for the production environment). Originally, it's been written to be super easy to install on Heroku. The installation process explains how to deploy your own instance of the backend on Heroku.

<a href="http://shakereport.com/">Go to our website to get more information</a>


#Shake Report?
Shake Reporter is a framework that allows you to easily get bug reports from users of your mobile application. When you see something wrong, shake the device, and report the issue with a custom message. You can either receive reports by email or configure a shake report backend which will collect and classify the reports.
# Requirement

* MongoDB
* Ruby 1.9.3

# Installation

Clone the repository:
`git clone git@github.com:jayztemplier/ShakeReportServer.git`

Enter in the ShakeReportServer folder:
`cd ShakeReportServer`

Run the bundle command:
`bundle install`

Set up a user:
`export SR_USERNAME="jayztemplier"`
`export SR_PASSWORD="your_password"`
If you don't setup a user, by default the website won't be protected.

Launch the rails app:
`rails s`	

# Deploy on Heroku
Create an Heroku app:
`heroku create my_app_name`

Enable SendGrid and Scheduler for your heroku app
`
heroku addons:add scheduler`
`heroku addons:add sendgrid:starter
`

Setup the user config:
`heroku config:set SR_USERNAME=myusername`
heroku config:set SR_PASSWORD=mypassword`

Deploy!
`git push heroku master`

Check that it's running by visiting `http://localhost:3000`
A prompt will ask you your username and password. Use the logins you just created.
# Features

* List of the reports sent from the devices
* Possibility to archive the report

# License
SRReport is available under the MIT license. See the LICENSE file for more info

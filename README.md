# Shake Report Server

Shake Report server is a small server that you can use as a backend for the Shake Report iOS library
https://github.com/jayztemplier/ShakeReport

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

Launch the rails app:
`rails s`	

Check that it's running by visiting `http://localhost:3000`
A prompt will ask you your username and password. Use the logins you just created.
# Features

* List of the reports sent from the devices
* Possibility to archive the report

# License
SRReport is available under the MIT license. See the LICENSE file for more info
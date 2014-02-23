ShakeReport::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  #config.action_mailer.delivery_method = :sendmail
  #config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.gmail.com',
      :domain         => 'example.com',
      :port           => 587,
      :user_name      => ENV['SR_GMAIL_ADDRESS'],
      :password       => ENV['SR_GMAIL_PWD'],
      :authentication => :plain
  }


  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Do not compress assets
  config.assets.compress = false
  config.serve_static_assets = true

  # Expands the lines which load the assets
  config.assets.debug = true

  #auth
  ENV['GITHUB_KEY'] = "fe3874deb84a3d6a85f1"
  ENV['GITHUB_SECRET'] = "5cd6de68980a8d3d0a4c7161310ff8089ff1c916"

          # paperclip configuration
  if ENV['AWS_BUCKET'] && ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
    }
  else
    config.paperclip_defaults = {
      :path => ":rails_root/public/uploads/:class/:id/:filename",
      :url => "/uploads/:class/:id/:filename",
    }
  end
  
end

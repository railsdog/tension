# Email settings
require "smtp_tls"

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :user_name => ENV['SMTP_USERNAME'],
  :enable_starttls_auto => true,  
  :password => ENV['SMTP_PASSWORD'],
  :authentication => :plain
}
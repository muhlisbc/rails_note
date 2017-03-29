class ApplicationMailer < ActionMailer::Base
  default from: (Rails.env.production? ? ENV["DEFAULT_FROM_EMAIL"] : "admin@domain.com")
  layout 'mailer'

end

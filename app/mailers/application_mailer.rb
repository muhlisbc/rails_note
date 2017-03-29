class ApplicationMailer < ActionMailer::Base
  default from: default_email_from
  layout 'mailer'

  private

  def default_email_from
    Rails.env.production? ENV["DEFAULT_FROM_EMAIL"] : "admin@domain.com"
  end
end

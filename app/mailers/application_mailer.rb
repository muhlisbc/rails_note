class ApplicationMailer < ActionMailer::Base
  default from: default_from_email
  layout 'mailer'

  private

  def default_from_email
    Rails.env.production? ENV["DEFAULT_FROM_EMAIL"] : "admin@domain.com"
  end
end

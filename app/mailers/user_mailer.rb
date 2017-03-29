class UserMailer < ApplicationMailer

  def confirm_email(email)
    @to     = email
    @title  = "Please confirm your account"
    @text   = "Please click the link below to confirm your account:"
    @link   = confirm_email_account_url(token: Crypt.encrypt(email))
    @link_text = "Confirm your account"
    mail(to: @to, subject: [@title, @to].join(", "))
  end

  def reset_password(email, password_digest)
    @to     = email
    @title  = "Reset password request"
    @text   = "Please click the link below to reset your password:"
    @link   = reset_password_account_url(token: Crypt.encrypt(email), digest: Crypt.encrypt(password_digest))
    @link_text = "Reset your password"
    mail(to: @to, subject: [@title, @to].join(", "))
  end

end

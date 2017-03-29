module Crypt

  def self.encrypt(data)
    crypt.encrypt_and_sign data
  end

  def self.decrypt(data)
    crypt.decrypt_and_verify(data) rescue nil
  end

  private

  def self.crypt
    ActiveSupport::MessageEncryptor.new(Digest::MD5.hexdigest(Rails.application.secrets.secret_key_base))
  end

end

# module Mail
#   class Message
#     attr_accessor :anu
#   end
# end
#
# module ActionMailer
#   class Base
#     def cust_anu(arg)
#       message.anu = arg
#     end
#   end
# end
#                   :api_version,
#                   :protocol,
#                   :mailgun_host,
#                   :test_mode,
#                   :domain
#
#     def configure
#       yield self
#       true
#     end
#     alias_method :config, :configure
#   end
#
#   class Mailer
#     attr_accessor :config
#     def initialize(config ={})
#       @config = config
#     end
#   end
#
#   class Railtie < ::Rails::Railtie
#     config.before_configuration do
#       ActionMailer::Base.add_delivery_method :testgun, Testgun::Mailer
#     end
#   end
#
# end
#
# Testgun.configure do |config|
#   config.api_key = "akakak"
# end

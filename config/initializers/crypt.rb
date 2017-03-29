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

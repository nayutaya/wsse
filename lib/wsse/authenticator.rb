# coding: utf-8

require "wsse/username_token"

module Wsse
  module Authenticator
    def self.authenticate(token, username, password)
      if username != token.username
        return :wrong_username
      end

      digest = UsernameToken.create_password_digest(password, token.nonce, token.created)
      if digest != token.digest
        return :wrong_password
      end

      return :success
    end
  end
end

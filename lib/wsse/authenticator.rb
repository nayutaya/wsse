# coding: utf-8

require "wsse/username_token"

module Wsse
  module Authenticator
    def self.authenticate(token, username, password)
      return :wrong_username unless judge_username(token, username)
      return :wrong_password unless judge_password(token, password)
      return :success
    end

    def self.judge_username(token, username)
      return (token.username == username)
    end
    private_class_method :judge_username

    def self.judge_password(token, password)
      digest = UsernameToken.create_password_digest(password, token.nonce, token.created)
      return (token.digest == digest)
    end
    private_class_method :judge_password
  end
end

# coding: utf-8

require "wsse/username_token_builder"
require "wsse/username_token_parser"

module Wsse
  class HttpHeader
    def initialize(username, password)
      @username = username
      @password = password
    end

    attr_reader :username, :password

    def create_token(nonce = nil, created = nil)
      return UsernameTokenBuilder.create_token(@username, @password, nonce, created)
    end

    def parse_token(token)
      return UsernameTokenParser.parse_token(token)
    end

    def match_username?(params)
      username = (params["Username"] || raise(ArgumentError))
      return (@username == username)
    end

    def match_password?(params)
      digest  = (params["PasswordDigest"] || raise(ArgumentError)).unpack("m")[0]
      nonce   = (params["Nonce"]          || raise(ArgumentError)).unpack("m")[0]
      created = (params["Created"]        || raise(ArgumentError))

      digest2 = UsernameTokenBuilder.create_password_digest(@password, nonce, created)

      return (digest == digest2)
    end

    # FIXME: リピート攻撃に対処
    # FIXME: Createdの範囲を制限
    def authenticate(token)
      params = self.parse_token(token)
      return :invalid_token  if params.nil?
      return :wrong_username unless self.match_username?(params)
      return :wrong_password unless self.match_password?(params)
      return :success
    end

    def authenticate?(token)
      return (self.authenticate(token) == :success)
    end
  end
end

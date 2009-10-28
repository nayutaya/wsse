# coding: utf-8

require "wsse/username_token_builder"

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
  end
end

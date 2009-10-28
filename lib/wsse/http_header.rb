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
      return UsernameTokenParser.parse(token)
    end
  end
end

# coding: utf-8

module Wsse
  class HttpHeader
    def initialize(username, password)
      @username = username
      @password = password
    end

    attr_reader :username, :password
  end
end

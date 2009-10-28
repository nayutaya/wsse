# coding: utf-8

module Wsse
  class UsernameToken
    def initialize(username, digest, nonce, created)
      @username = username
      @digest   = digest
      @nonce    = nonce
      @created  = created
    end

    attr_reader :username, :digest, :nonce, :created
  end
end

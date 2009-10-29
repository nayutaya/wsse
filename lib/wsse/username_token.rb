# coding: utf-8

require "time"
require "digest/sha1"

module Wsse
  class UsernameToken
    def initialize(username, digest, nonce, created)
      @username = username
      @digest   = digest  # binary
      @nonce    = nonce   # binary
      @created  = created # Time object
    end

    attr_reader :username, :digest, :nonce, :created

    def self.create_random_binary(size)
      return size.times.map { rand(256) }.pack("C*")
    end

    def self.create_password_digest(password, nonce, created)
      return Digest::SHA1.digest(nonce + created.iso8601 + password)
    end

    def self.build(username, password, nonce, created)
      digest = self.create_password_digest(password, nonce, created)
      return self.new(username, digest, nonce, created)
    end

    # TODO: self.format_token(username, digest, nonce, created) -> str
    # TODO: self.parse(token) -> UsernameToken
    # TODO: self.parse_time(time) -> Time
    # TODO: base64encoded_digest -> str
    # TODO: base64encoded_nonce -> str
    # TODO: formatted_created -> str
    # TODO: create_token_params -> Hash
    # TODO: create_token -> Hash
  end
end

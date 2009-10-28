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

    # TODO: self.create_nonce(size) -> str
    # TODO: self.create_password_digest(password, nonce, created) -> str
    # TODO: self.format_token(username, digest, nonce, created) -> str
    # TODO: self.parse(token) -> UsernameToken
    # TODO: self.parse_time(time) -> Time
    # TODO: self.build(username, password, nonce, created) -> UsernameToken
    # TODO: base64encoded_digest -> str
    # TODO: base64encoded_nonce -> str
    # TODO: formatted_created -> str
    # TODO: create_token_params -> Hash
    # TODO: create_token -> Hash
  end
end

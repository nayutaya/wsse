# coding: utf-8

module Wsse
  module UsernameTokenParser
    def self.parse(value)
      pattern = /\AUsernameToken Username="(.+?)", PasswordDigest="(.+?)", Nonce="(.+?)", Created="(.+?)"\z/

      if pattern =~ value.to_s
        return {
          "Username"       => $1,
          "PasswordDigest" => $2,
          "Nonce"          => $3,
          "Created"        => $4,
        }
      else
        return nil
      end
    end
  end
end

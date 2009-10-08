# coding: utf-8

module Wsse
  module UsernameTokenParser
    def self.parse(value)
      pattern1 = /\AUsernameToken Username="(.+?)", PasswordDigest="(.+?)", Nonce="(.+?)", Created="(.+?)"\z/
      pattern2 = /\AUsernameToken Username="(.+?)", PasswordDigest="(.+?)", Created="(.+?)", Nonce="(.+?)"\z/

      if pattern1 =~ value.to_s
        return {
          "Username"       => $1,
          "PasswordDigest" => $2,
          "Nonce"          => $3,
          "Created"        => $4,
        }
      elsif pattern2 =~ value.to_s
        return {
          "Username"       => $1,
          "PasswordDigest" => $2,
          "Created"        => $3,
          "Nonce"          => $4,
        }
      else
        return nil
      end
    end
  end
end

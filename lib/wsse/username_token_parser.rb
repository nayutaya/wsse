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

    def self.parse_time(value)
      return nil if value.to_s.empty?
      if /\A(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)Z\z/ =~ value.to_s
        return Time.utc($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
      else
        return nil
      end
    end
  end
end

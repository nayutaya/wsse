# coding: utf-8

module Wsse
  module UsernameTokenParser
    def self.parse_token(token)
      if /\AUsernameToken (.+?=".+?"(?:, .+?=".+?")*)\z/ =~ token.to_s
        return $1.scan(/(?:\A|, )(.+?)="(.+?)"/).inject({}) { |memo, (key, value)|
          memo[key] = value
          memo
        }
      else
        return nil
      end
    end

    def self.parse_time(value)
      if /\A(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)Z\z/ =~ value.to_s
        return Time.utc(*($~.captures.map { |s| s.to_i }))
      else
        return nil
      end
    end
  end
end

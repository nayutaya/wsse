# coding: utf-8

require "time"

module Wsse
  module UsernameTokenBuilder
    def self.create_created_time(time = Time.now)
      return time.utc.iso8601
    end

    def self.create_nonce
      return 20.times.map { rand(256) }.pack("C*")
    end
  end
end

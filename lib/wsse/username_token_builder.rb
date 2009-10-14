# coding: utf-8

require "time"

module Wsse
  module UsernameTokenBuilder
    def self.create_created_time(time = Time.now)
      return time.utc.iso8601
    end
  end
end

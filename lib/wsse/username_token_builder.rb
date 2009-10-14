# coding: utf-8

require "time"
require "digest/sha1"

module Wsse
  module UsernameTokenBuilder
    def self.create_created_time(time = Time.now)
      return time.utc.iso8601
    end

    def self.create_nonce
      return 20.times.map { rand(256) }.pack("C*")
    end

    def self.create_wsse_params(username, password, nonce, created)
      digest = Digest::SHA1.digest(nonce + created + password)
      return {
        "Username"       => username,
        "PasswordDigest" => [digest].pack("m").chomp,
        "Nonce"          => [nonce].pack("m").chomp,
        "Created"        => created,
      }
    end
  end
end

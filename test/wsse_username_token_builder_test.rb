# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token_builder"

class WsseUsernameTokenBuilderTest < Test::Unit::TestCase
  def setup
    @mod = Wsse::UsernameTokenBuilder
  end

  def test_create_created_time
    assert_equal(
      "2000-01-01T00:00:00Z",
      @mod.create_created_time(Time.utc(2000, 1, 1, 0, 0, 0)))
    assert_equal(
      "2001-12-31T23:59:59Z",
      @mod.create_created_time(Time.utc(2001, 12, 31, 23, 59, 59)))
    Kagemusha::DateTime.at(Time.utc(2009, 1, 2, 3, 4, 5)) {
      assert_equal(
        "2009-01-02T03:04:05Z",
        @mod.create_created_time())
    }
  end

  def test_create_nonce
    srand(0)
    assert_equal(20, @mod.create_nonce.size)
    assert_equal(10, 10.times.map { @mod.create_nonce }.uniq.size)
  end

  def test_create_wsse_params
    expected = {
      "Username"       => "username",
      "PasswordDigest" => [Digest::SHA1.digest("nonce2000-01-01T00:00:00Zpassword")].pack("m").chomp,
      "Nonce"          => ["nonce"].pack("m").chomp,
      "Created"        => "2000-01-01T00:00:00Z",
    }
    assert_equal(
      expected,
      @mod.create_wsse_params("username", "password", "nonce", "2000-01-01T00:00:00Z"))
  end

  def test_create_wsse_params__default_created
    expected = {
      "Username"       => "username1",
      "PasswordDigest" => [Digest::SHA1.digest("nonce2001-02-03T04:05:06Zpassword1")].pack("m").chomp,
      "Nonce"          => ["nonce"].pack("m").chomp,
      "Created"        => "2001-02-03T04:05:06Z",
    }
    musha = Kagemusha.new(@mod)
    musha.defs(:create_created_time) { "2001-02-03T04:05:06Z" }
    musha.swap {
      assert_equal(
        expected,
        @mod.create_wsse_params("username1", "password1", "nonce"))
    }
  end

  def test_create_wsse_params__default_nonce
    expected = {
      "Username"       => "username2",
      "PasswordDigest" => [Digest::SHA1.digest("foobarbaz2001-02-03T04:05:06Zpassword2")].pack("m").chomp,
      "Nonce"          => ["foobarbaz"].pack("m").chomp,
      "Created"        => "2001-02-03T04:05:06Z",
    }
    musha = Kagemusha.new(@mod)
    musha.defs(:create_nonce) { "foobarbaz" }
    musha.defs(:create_created_time) { "2001-02-03T04:05:06Z" }
    musha.swap {
      assert_equal(
        expected,
        @mod.create_wsse_params("username2", "password2"))
    }
  end
end

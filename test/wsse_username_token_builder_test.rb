# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token_builder"

class WsseUsernameTokenBuilderTest < Test::Unit::TestCase
  def setup
    @mod = Wsse::UsernameTokenBuilder
    @musha = Kagemusha.new(@mod)
  end

  def test_create_created_time
    assert_equal("2000-01-01T00:00:00Z", @mod.create_created_time(Time.utc(2000, 1, 1, 0, 0, 0)))
    assert_equal("2001-12-31T23:59:59Z", @mod.create_created_time(Time.utc(2001, 12, 31, 23, 59, 59)))
    Kagemusha::DateTime.at(Time.utc(2009, 1, 2, 3, 4, 5)) {
      assert_equal("2009-01-02T03:04:05Z", @mod.create_created_time())
    }
  end

  def test_create_nonce
    srand(0)
    assert_equal(20, @mod.create_nonce(20).size)
    assert_equal(30, @mod.create_nonce(30).size)
    assert_equal(10, 10.times.map { @mod.create_nonce(20) }.uniq.size)
  end

  def test_create_token_params
    username = "username"
    password = "password"
    nonce    = "nonce"
    created  = "2000-01-01T00:00:00Z"
    expected = {
      "Username"       => username,
      "PasswordDigest" => [Digest::SHA1.digest("#{nonce}#{created}#{password}")].pack("m").chomp,
      "Nonce"          => [nonce].pack("m").chomp,
      "Created"        => created,
    }
    assert_equal(expected, @mod.create_token_params(username, password, nonce, created))
  end

  def test_create_token_params__default_created
    username = "username1"
    password = "password1"
    nonce    = "nonce"
    created  = "2001-02-03T04:05:06Z"
    expected = {
      "Username"       => username,
      "PasswordDigest" => [Digest::SHA1.digest("#{nonce}#{created}#{password}")].pack("m").chomp,
      "Nonce"          => [nonce].pack("m").chomp,
      "Created"        => created,
    }
    @musha.defs(:create_created_time) { created }
    @musha.swap {
      assert_equal(expected, @mod.create_token_params(username, password, nonce))
    }
  end

  def test_create_token_params__default_nonce
    username = "username2"
    password = "password2"
    nonce    = "foobarbaz"
    created  = "2001-02-03T04:05:06Z"
    expected = {
      "Username"       => username,
      "PasswordDigest" => [Digest::SHA1.digest("#{nonce}#{created}#{password}")].pack("m").chomp,
      "Nonce"          => [nonce].pack("m").chomp,
      "Created"        => created,
    }
    @musha.defs(:create_nonce) { nonce }
    @musha.defs(:create_created_time) { created }
    @musha.swap {
      assert_equal(expected, @mod.create_token_params(username, password))
    }
  end

  def test_format_token
    basic = {
      "Username"       => "username",
      "PasswordDigest" => "digest",
      "Nonce"          => "nonce",
      "Created"        => "created",
    }
    assert_equal(
      %|UsernameToken Username="username", PasswordDigest="digest", Nonce="nonce", Created="created"|,
      @mod.format_token(basic))
    assert_raise(ArgumentError) { @mod.format_token(basic.merge("Username"       => nil)) }
    assert_raise(ArgumentError) { @mod.format_token(basic.merge("PasswordDigest" => nil)) }
    assert_raise(ArgumentError) { @mod.format_token(basic.merge("Nonce"          => nil)) }
    assert_raise(ArgumentError) { @mod.format_token(basic.merge("Created"        => nil)) }
  end

  def test_create_token
    assert_equal(
      %|UsernameToken Username="username", PasswordDigest="DzunnEf/2CKuhInsnmEHonW5qQs=", Nonce="bm9uY2U=", Created="2000-01-01T00:00:00Z"|,
      @mod.create_token("username", "password", "nonce", "2000-01-01T00:00:00Z"))
  end

  def test_create_token__default_created
    @musha.defs(:create_created_time) { "2001-02-03T04:05:06Z" }
    @musha.swap {
      assert_equal(
        %|UsernameToken Username="username1", PasswordDigest="lTTtMZC0IJyrV8aITFjLgdDzXzw=", Nonce="bm9uY2U=", Created="2001-02-03T04:05:06Z"|,
        @mod.create_token("username1", "password1", "nonce"))
    }
  end

  def test_create_token__default_nonce
    @musha.defs(:create_nonce) { "foobarbaz" }
    @musha.defs(:create_created_time) { "2001-02-03T04:05:06Z" }
    @musha.swap {
      assert_equal(
        %|UsernameToken Username="username2", PasswordDigest="zmw1lW05c8tDlXsnU1IypUIt8uA=", Nonce="Zm9vYmFyYmF6", Created="2001-02-03T04:05:06Z"|,
        @mod.create_token("username2", "password2"))
    }
  end
end

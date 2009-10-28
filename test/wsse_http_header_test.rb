# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/http_header"

class WsseHttpHeaderTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::HttpHeader
    @basic = @klass.new("username", "password")
  end

  def test_initialize_and_accessor__1
    assert_equal("username", @basic.username)
    assert_equal("password", @basic.password)
  end

  def test_initialize_and_accessor__2
    header = @klass.new("a", "b")
    assert_equal("a", header.username)
    assert_equal("b", header.password)
  end

  def test_create_token
    assert_equal(
      Wsse::UsernameTokenBuilder.create_token("username", "password", "nonce", "2009-01-01T00:00:00"),
      @basic.create_token("nonce", "2009-01-01T00:00:00"))
  end

  def test_create_token__default_created
    token  = @basic.create_token("nonce")
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_create_token__default_nonce
    token  = @basic.create_token
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_parse_token
    token = Wsse::UsernameTokenBuilder.create_token("foo", "bar", "baz", "2000-01-01T00:00:00")

    expected = {
      "Username"       => "foo",
      "PasswordDigest" => "qzlKm7PqSP1MPDHUJXz5yhb0ECg=",
      "Nonce"          => "YmF6",
      "Created"        => "2000-01-01T00:00:00",
    }
    assert_equal(expected, @basic.parse_token(token))
  end

  def test_match_username__1
    assert_equal(true,  @basic.match_username?("Username" => "username"))
    assert_equal(false, @basic.match_username?("Username" => "USERNAME"))
  end

  def test_match_username__2
    header = @klass.new("foo", "bar")
    assert_equal(true,  header.match_username?("Username" => "foo"))
    assert_equal(false, header.match_username?("Username" => nil))
  end
end

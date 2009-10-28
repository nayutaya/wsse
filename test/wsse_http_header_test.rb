# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/http_header"

class WsseHttpHeaderTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::HttpHeader
  end

  def test_initialize_and_accessor1
    header = @klass.new("username", "password")
    assert_equal("username", header.username)
    assert_equal("password", header.password)
  end

  def test_initialize_and_accessor2
    header = @klass.new("a", "b")
    assert_equal("a", header.username)
    assert_equal("b", header.password)
  end

  def test_create_token
    header = @klass.new("username", "password")
    assert_equal(
      Wsse::UsernameTokenBuilder.create_token("username", "password", "nonce", "2009-01-01T00:00:00"),
      header.create_token("nonce", "2009-01-01T00:00:00"))
  end

  def test_create_token__default_created
    header = @klass.new("username", "password")
    token  = header.create_token("nonce")
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_create_token__default_nonce
    header = @klass.new("username", "password")
    token  = header.create_token
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_parse_token
    token = Wsse::UsernameTokenBuilder.create_token("foo", "bar", "baz", "2000-01-01T00:00:00")

    header = @klass.new("username", "password")
    expected = {
      "Username"       => "foo",
      "PasswordDigest" => "qzlKm7PqSP1MPDHUJXz5yhb0ECg=",
      "Nonce"          => "YmF6",
      "Created"        => "2000-01-01T00:00:00",
    }
    assert_equal(expected, header.parse_token(token))
  end

  def test_match_username?
    header1 = @klass.new("username", "password")
    assert_equal(true,  header1.match_username?("Username" => "username"))
    assert_equal(false, header1.match_username?("Username" => "USERNAME"))

    header2 = @klass.new("foo", "bar")
    assert_equal(true,  header2.match_username?("Username" => "foo"))
    assert_equal(false, header2.match_username?("Username" => nil))
  end
end

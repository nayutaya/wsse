# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/http_header"
require "wsse/username_token_parser"

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

  def test_create_header
    header = @klass.new("username", "password")
    assert_equal(
      Wsse::UsernameTokenBuilder.create_token("username", "password", "nonce", "2009-01-01T00:00:00"),
      header.create_token("nonce", "2009-01-01T00:00:00"))
  end

  def test_create_header__default_created
    header = @klass.new("username", "password")
    token  = header.create_token("nonce")
    params = Wsse::UsernameTokenParser.parse(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_create_header__default_nonce
    header = @klass.new("username", "password")
    token  = header.create_token
    params = Wsse::UsernameTokenParser.parse(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end
end

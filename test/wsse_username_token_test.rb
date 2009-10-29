# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token"

class WsseUsernameTokenTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::UsernameToken
  end

  def test_initialize_and_accessor
    created = Time.utc(2000, 1, 1)
    token = Wsse::UsernameToken.new("username", "digest", "nonce", created)
    assert_equal("username", token.username)
    assert_equal("digest",   token.digest)
    assert_equal("nonce",    token.nonce)
    assert_equal(created,    token.created)
  end

  def test_create_random_binary
    srand(0)
    assert_equal(20, @klass.create_random_binary(20).size)
    assert_equal(30, @klass.create_random_binary(30).size)
    assert_equal(10, 10.times.map { @klass.create_random_binary(20) }.uniq.size)
  end

  def test_create_password_digest
    assert_equal(
      Digest::SHA1.digest("nonce2000-01-01T00:00:00Zpassword"),
      @klass.create_password_digest("password", "nonce", Time.utc(2000, 1, 1)))
    assert_equal(
      Digest::SHA1.digest("NONCE1999-12-31T23:59:59ZPASSWORD"),
      @klass.create_password_digest("PASSWORD", "NONCE", Time.utc(1999, 12, 31, 23, 59, 59)))
  end

  def test_build
    created = Time.utc(2000, 1, 1)
    digest  = @klass.create_password_digest("password", "nonce", created)
    token = @klass.build("username", "password", "nonce", created)
    assert_kind_of(@klass, token)
    assert_equal("username", token.username)
    assert_equal(digest,     token.digest)
    assert_equal("nonce",    token.nonce)
    assert_equal(created,    token.created)
  end
end

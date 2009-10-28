# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/http_header"

class WsseHttpHeaderTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::HttpHeader
    @basic = @klass.new("username", "password")
  end

  def test_initialize_and_accessor__1
    header = @basic
    assert_equal("username", header.username)
    assert_equal("password", header.password)
  end

  def test_initialize_and_accessor__2
    header = @klass.new("a", "b")
    assert_equal("a", header.username)
    assert_equal("b", header.password)
  end

  def test_create_token
    header = @basic
    assert_equal(
      create_token(header.username, header.password, "nonce", "2009-01-01T00:00:00"),
      header.create_token("nonce", "2009-01-01T00:00:00"))
  end

  def test_create_token__default_created
    header = @basic
    token  = header.create_token("nonce")
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_create_token__default_nonce
    header = @basic
    token  = header.create_token
    params = Wsse::UsernameTokenParser.parse_token(token)
    assert_equal(
      %w[Username Nonce PasswordDigest Created].sort,
      params.keys.sort)
  end

  def test_parse_token
    header = @basic
    token  = create_token("foo", "bar", "baz", "2000-01-01T00:00:00")

    expected = {
      "Username"       => "foo",
      "PasswordDigest" => "qzlKm7PqSP1MPDHUJXz5yhb0ECg=",
      "Nonce"          => "YmF6",
      "Created"        => "2000-01-01T00:00:00",
    }
    assert_equal(expected, header.parse_token(token))
  end

  def test_match_username__1
    header = @basic
    assert_equal(true,  header.match_username?("Username" => header.username))
    assert_equal(false, header.match_username?("Username" => header.username + "x"))
  end

  def test_match_username__2
    header = @klass.new("foo", "bar")
    assert_equal(true,  header.match_username?("Username" => header.username))
    assert_equal(false, header.match_username?("Username" => header.username + "x"))
  end

  def test_match__username__invalid
    header = @basic
    assert_raise(ArgumentError) {
      header.match_username?("Username" => nil)
    }
  end

  def test_match_password
    header  = @basic
    params1 = Wsse::UsernameTokenBuilder.create_token_params("username", "password", "nonce", "2000-01-01T00:00:00")
    params2 = Wsse::UsernameTokenBuilder.create_token_params("foo", "bar", "baz", "2000-12-31T23:59:59")
    assert_equal(true,  header.match_password?(params1))
    assert_equal(false, header.match_password?(params1.merge("PasswordDigest" => params2["PasswordDigest"])))
    assert_equal(false, header.match_password?(params1.merge("Nonce" => params2["Nonce"])))
    assert_equal(false, header.match_password?(params1.merge("Created" => params2["Created"])))
  end

  def test_match_password__invalid
    header = @basic
    params = {"PasswordDigest" => "", "Nonce" => "", "Created" => ""}
    assert_raise(ArgumentError) { header.match_password?(params.merge("PasswordDigest" => nil)) }
    assert_raise(ArgumentError) { header.match_password?(params.merge("Nonce"          => nil)) }
    assert_raise(ArgumentError) { header.match_password?(params.merge("Created"        => nil)) }
  end

  def test_authenticate__success
    header = @basic
    token  = create_token("username", "password")
    assert_equal(:success, header.authenticate(token))
  end

  def test_authenticate__invalid_token
    header = @basic
    token  = "invalid-token"
    assert_equal(:invalid_token, header.authenticate(token))
  end

  def test_authenticate__wrong_username
    header = @basic
    token  = create_token("foo", "password")
    assert_equal(:wrong_username, header.authenticate(token))
  end

  def test_authenticate__wrong_password
    header = @basic
    token  = create_token("username", "bar")
    assert_equal(:wrong_password, header.authenticate(token))
  end

  def test_authenticate_p
    header = @basic
    assert_equal(true,  header.authenticate?(create_token("username", "password")))
    assert_equal(false, header.authenticate?("invalid-token"))
    assert_equal(false, header.authenticate?(create_token("foo", "password")))
    assert_equal(false, header.authenticate?(create_token("username", "bar")))
  end

  private

  def create_token(username, password, nonce = nil, created = nil)
    return Wsse::UsernameTokenBuilder.create_token(username, password, nonce, created)
  end
end

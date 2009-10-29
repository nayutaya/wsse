# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/authenticator"

class WsseAuthenticatorTest < Test::Unit::TestCase
  def setup
    @mod = Wsse::Authenticator
  end

  def test_authenticate__success
    token = Wsse::UsernameToken.build("username", "password")
    assert_equal(:success, @mod.authenticate(token, "username", "password"))
  end

  def test_authenticate__wrong_username
    token = Wsse::UsernameToken.build("username", "password")
    assert_equal(:wrong_username, @mod.authenticate(token, "foo", "password"))
  end

  def test_authenticate__wrong_password
    token = Wsse::UsernameToken.build("username", "password")
    assert_equal(:wrong_password, @mod.authenticate(token, "username", "baz"))
  end

  def test_authenticate_p
    token = Wsse::UsernameToken.build("username", "password")
    assert_equal(true,  @mod.authenticate?(token, "username", "password"))
    assert_equal(false, @mod.authenticate?(token, "foo", "password"))
    assert_equal(false, @mod.authenticate?(token, "username", "baz"))
  end
end

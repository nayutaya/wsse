# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token"

class WsseUsernameTokenTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::UsernameToken
  end

  def test_initialize_and_accessor
    token = Wsse::UsernameToken.new("username", "digest", "nonce", "created")
    assert_equal("username", token.username)
    assert_equal("digest",   token.digest)
    assert_equal("nonce",    token.nonce)
    assert_equal("created",  token.created)
  end
end

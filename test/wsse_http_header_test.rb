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
end

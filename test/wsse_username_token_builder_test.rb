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
    Kagemusha::DateTime.at(2009, 1, 2, 3 + 9, 4, 5) {
      assert_equal(
        "2009-01-02T03:04:05Z",
        @mod.create_created_time())
    }
  end

  def test_true
    assert true
  end
end

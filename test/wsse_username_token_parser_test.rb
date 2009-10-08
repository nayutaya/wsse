# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token_parser"

class WsseUsernameTokenParserTest < Test::Unit::TestCase
  def setup
    @mod = Wsse::UsernameTokenParser
  end

  def test_parse__1
    # http://www.teria.com/~koseki/tools/wssegen/
    # UserName: test, Password: test, Nonce: auto, Created: auto
    value = %|UsernameToken Username="test", PasswordDigest="XYuMkeTAdwEwKhyU/4uw/pbvqrc=", Nonce="Mzg5ODU5MDExYTljODQ5Yg==", Created="2009-10-08T02:31:57Z"|
    expected = {
      "Username"       => "test",
      "PasswordDigest" => "XYuMkeTAdwEwKhyU/4uw/pbvqrc=",
      "Nonce"          => "Mzg5ODU5MDExYTljODQ5Yg==",
      "Created"        => "2009-10-08T02:31:57Z", # FIXME: str -> time
    }
    assert_equal(expected, @mod.parse(value))
  end

  def test_parse__2
    # http://d.hatena.ne.jp/keyword/%A4%CF%A4%C6%A4%CA%A5%D5%A5%A9%A5%C8%A5%E9%A5%A4%A5%D5AtomAPI
    value = %|UsernameToken Username="hatena", PasswordDigest="ZCNaK2jrXr4+zsCaYK/YLUxImZU=", Nonce="Uh95NQlviNpJQR1MmML+zq6pFxE=", Created="2005-01-18T03:20:15Z"|
    expected = {
      "Username"       => "hatena",
      "PasswordDigest" => "ZCNaK2jrXr4+zsCaYK/YLUxImZU=",
      "Nonce"          => "Uh95NQlviNpJQR1MmML+zq6pFxE=",
      "Created"        => "2005-01-18T03:20:15Z", # FIXME: str -> time
    }
    assert_equal(expected, @mod.parse(value))
  end

  def test_parse__3
    # http://www.witha.jp/blog/archives/2004/06/_atom_api.html
    value = %|UsernameToken Username="Melody", PasswordDigest="VfJavTaTy3BhKkeY/WVu9L6cdVA=", Created="2004-01-20T01:09:39Z", Nonce="7c19aeed85b93d35ba42e357f10ca19bf314d622"|
    expected = {
      "Username"       => "Melody",
      "PasswordDigest" => "VfJavTaTy3BhKkeY/WVu9L6cdVA=",
      "Nonce"          => "7c19aeed85b93d35ba42e357f10ca19bf314d622",
      "Created"        => "2004-01-20T01:09:39Z",
    }
    assert_equal(expected, @mod.parse(value))
  end

  def test_parse__nil
    assert_equal(nil, @mod.parse(nil))
  end

  def test_parse__empty
    assert_equal(nil, @mod.parse(""))
  end

  def test_parse_time
    assert_equal(Time.utc(2009,  1,  1,  0,  0,  0), @mod.parse_time("2009-01-01T00:00:00Z"))
    assert_equal(Time.utc(2009, 12, 31, 23, 59, 59), @mod.parse_time("2009-12-31T23:59:59Z"))
    assert_equal(Time.utc(2001,  2,  3,  4,  5,  6), @mod.parse_time("2001-02-03T04:05:06Z"))
  end

  def test_parse_time__empty
    assert_equal(nil, @mod.parse_time(nil))
    assert_equal(nil, @mod.parse_time(""))
  end
end

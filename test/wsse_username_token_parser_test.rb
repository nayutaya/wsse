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

  def test_parse__nil
    assert_equal(nil, @mod.parse(nil))
  end

  def test_parse__empty
    assert_equal(nil, @mod.parse(""))
  end
end

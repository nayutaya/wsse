# coding: utf-8

require File.dirname(__FILE__) + "/test_helper"
require "wsse/username_token"

class WsseUsernameTokenTest < Test::Unit::TestCase
  def setup
    @klass = Wsse::UsernameToken
    @musha = Kagemusha.new(@klass)
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
      Digest::SHA1.digest("bar1999-12-31T23:59:59Zfoo"),
      @klass.create_password_digest("foo", "bar", Time.utc(1999, 12, 31, 23, 59, 59)))
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

  def test_build__default_created
    created = Time.utc(1999, 12, 31, 23, 59, 59)

    token =
      Kagemusha::DateTime.at(created) {
        @klass.build("username", "password", "nonce")
      }

    assert_equal(created, token.created)
  end

  def test_build__default_nonce
    nonce = "foo"

    @musha.defs(:create_random_binary) { |size|
      raise unless size == 20
      nonce
    }
    token =
      @musha.swap {
        @klass.build("username", "password")
      }

    assert_equal(nonce, token.nonce)
  end

  def test_parse_token__1
    # http://www.teria.com/~koseki/tools/wssegen/
    # UserName: test, Password: test, Nonce: auto, Created: auto
    token = %|UsernameToken Username="test", PasswordDigest="XYuMkeTAdwEwKhyU/4uw/pbvqrc=", Nonce="Mzg5ODU5MDExYTljODQ5Yg==", Created="2009-10-08T02:31:57Z"|
    expected = {
      "Username"       => "test",
      "PasswordDigest" => "XYuMkeTAdwEwKhyU/4uw/pbvqrc=",
      "Nonce"          => "Mzg5ODU5MDExYTljODQ5Yg==",
      "Created"        => "2009-10-08T02:31:57Z",
    }
    assert_equal(expected, @klass.parse_token(token))
  end

  def test_parse_token__2
    # http://d.hatena.ne.jp/keyword/%A4%CF%A4%C6%A4%CA%A5%D5%A5%A9%A5%C8%A5%E9%A5%A4%A5%D5AtomAPI
    token = %|UsernameToken Username="hatena", PasswordDigest="ZCNaK2jrXr4+zsCaYK/YLUxImZU=", Nonce="Uh95NQlviNpJQR1MmML+zq6pFxE=", Created="2005-01-18T03:20:15Z"|
    expected = {
      "Username"       => "hatena",
      "PasswordDigest" => "ZCNaK2jrXr4+zsCaYK/YLUxImZU=",
      "Nonce"          => "Uh95NQlviNpJQR1MmML+zq6pFxE=",
      "Created"        => "2005-01-18T03:20:15Z",
    }
    assert_equal(expected, @klass.parse_token(token))
  end

  def test_parse_token__3
    # http://www.witha.jp/blog/archives/2004/06/_atom_api.html
    token = %|UsernameToken Username="Melody", PasswordDigest="VfJavTaTy3BhKkeY/WVu9L6cdVA=", Created="2004-01-20T01:09:39Z", Nonce="7c19aeed85b93d35ba42e357f10ca19bf314d622"|
    expected = {
      "Username"       => "Melody",
      "PasswordDigest" => "VfJavTaTy3BhKkeY/WVu9L6cdVA=",
      "Nonce"          => "7c19aeed85b93d35ba42e357f10ca19bf314d622",
      "Created"        => "2004-01-20T01:09:39Z",
    }
    assert_equal(expected, @klass.parse_token(token))
  end

  def test_parse_token__empty
    assert_equal(nil, @klass.parse_token(nil))
    assert_equal(nil, @klass.parse_token(""))
  end

  def test_parse_time
    assert_equal(Time.utc(2000,  1,  1,  0,  0,  0), @klass.parse_time("2000-01-01T00:00:00Z"))
    assert_equal(Time.utc(1999, 12, 31, 23, 59, 59), @klass.parse_time("1999-12-31T23:59:59Z"))
    assert_equal(Time.utc(2001,  2,  3,  4,  5,  6), @klass.parse_time("2001-02-03T04:05:06Z"))
  end

  def test_parse_time__empty
    assert_equal(nil, @klass.parse_time(nil))
    assert_equal(nil, @klass.parse_time(""))
  end

  def test_format_token_values
    assert_equal(
      %|UsernameToken Username="a", PasswordDigest="b", Nonce="c", Created="d"|,
      @klass.format_token_values("a", "b", "c", "d"))
  end

  def test_base64encoded_digest
    token = @klass.new("username", "digest", "nonce", Time.utc(2000, 1, 1))
    assert_equal("ZGlnZXN0", token.base64encoded_digest)
  end

  def test_base64encoded_nonce
    token = @klass.new("username", "digest", "nonce", Time.utc(2000, 1, 1))
    assert_equal("bm9uY2U=", token.base64encoded_nonce)
  end

  def test_format
    token = @klass.build("username", "password", "nonce", Time.utc(2000, 1, 1))
    assert_equal(
      %|UsernameToken Username="username", PasswordDigest="DzunnEf/2CKuhInsnmEHonW5qQs=", Nonce="bm9uY2U=", Created="2000-01-01T00:00:00Z"|,
      token.format)
  end
end

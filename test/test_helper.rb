# coding: utf-8

require "test/unit"
require "rubygems"
require "kagemusha"
require "kagemusha/datetime"

begin
  require "redgreen"
rescue LoadError
  # nop
end

begin
  require "win32console" if /win32/ =~ RUBY_PLATFORM
rescue LoadError
  # nop
end

$:.unshift(File.dirname(__FILE__) + "/../lib")

require 'active_support'
require 'rspec'
require 'pry'

LIB ||= File.expand_path("../lib"     , __dir__)
HLP ||= File.expand_path("../helpers" , __dir__)

require "#{LIB}/base"
require 'active_support'
require 'rspec'

ENV['CODECLIMATE_REPO_TOKEN']='c7f27456a9496169224b2c13171f57a50507d8a8525c723b4996960d87430ebd'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

LIB ||= File.expand_path("../lib"     , File.dirname(__FILE__))

require "#{LIB}/base"
require 'pry' if DEBUG

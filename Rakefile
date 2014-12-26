# vim ft=ruby

# test at spec/rake/base_spec.rb

::MM_ROOT ||= __dir__

require 'colored'
require 'yaml'

load "./lib/rake/dev.rake"
load "./lib/rake/site.rake"
load "./lib/rake/bnet.rake"
load "./lib/rake/gcal.rake"

require "./lib/rake/loggers"

# ----- utility methods -----

include Rake::Loggers

def normalized_lang(input)
  return "en" if input == ''
  input.gsub('.','')
end

# vim ft=ruby

# test at spec/rake/base_spec.rb

require "./lib/base"

require 'colored'
require 'yaml'

load "./lib/rake/dev.rake"
load "./lib/rake/site.rake"
load "./lib/rake/data.rake"
load "./lib/rake/cron.rake"
load "./lib/rake/total.rake"

require "./lib/rake/loggers"

# ----- utility methods -----

include Rake::Loggers

stamp = Time.now.strftime("%m-%d %H:%M")
log "#{stamp} | MM_ENV=#{MM_ENV} BAMRU_FLAGS=#{TEST_FLAGS.join(':')}"

# ----- fini -----

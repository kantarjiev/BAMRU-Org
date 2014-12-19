# vim ft=ruby

require 'colored'
require 'yaml'

# ----- utility methods -----

LOGLEN = 75

def log(text)
  puts "--- #{text} ---".ljust(LOGLEN,'-').yellow
end

def info(text)
  puts " #{text} ".center(LOGLEN, '-').yellow
end

def normalized_lang(input)
  return "en" if input == ''
  input.gsub('.','')
end

# ----- rake tasks -----

namespace :dev do
  desc "Test task"
  task :test do
    info Time.now
  end

  desc "Live server for development"
  task :serve do
    cmd = "bundle exec middleman server"
    log cmd
    system cmd
  end
end

namespace :site do
  desc "Build the Site"
  task :build do
    cmd = "bundle exec middleman build"
    log cmd
    system cmd
  end

  desc "Deploy the Site"
  task :deploy do
    script = <<-EOF
    rm -rf /tmp/out
    cp -r out /tmp
    git add .
    git commit -am'update source files'
    git push
    git checkout gh-pages
    rm -rf *
    cp -r /tmp/out/* .
    git add .
    git commit -am'update website'
    git push
    git checkout master
    EOF
    script.each_line do |line|
      cleanline = line.chomp.strip
      log cleanline
      system cleanline
    end
  end
end

namespace :data do
  desc "Pull event data from BAMRU.net"
  task :pull do
    require_relative './lib/data_pull'
    include DataPull
    execute
  end
end

namespace :gcal do
  desc "Sync event data with Gcal"
  task :sync do
    info "gcal:sync - Under Construction"
  end
end

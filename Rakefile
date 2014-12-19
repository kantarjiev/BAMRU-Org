# vim ft=ruby

::MM_ROOT ||= __dir__

require 'colored'
require 'yaml'
require 'dotenv'

Dotenv.load

load "./lib/tasks/gcal.rake"

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
  desc "Download event data from BAMRU.net"
  task :download do
    require 'open-uri'
    url = "http://bamru.net/public/calendar.csv"
    csv_text = open(url).read.delete("^\u{0000}-\u{007F}")
    out_file = "data/calendar_downloaded.csv"
    File.open(out_file, 'w') {|f| f.puts csv_text}
    msg = `wc -l #{out_file}`.strip.chomp.split(' ')
    log "BAMRU.net event data has been downloaded"
    log "#{msg[0]} records saved to #{msg[1]}"
  end
end


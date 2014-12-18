# vim ft=ruby

require 'colored'
require 'yaml'

# ----- utility methods -----

def log(text)
  puts "--- #{text} ---".ljust(75,'-').yellow
end

def normalized_lang(input)
  return "en" if input == ''
  input.gsub('.','')
end

# ----- rake tasks -----

namespace :dev do
  desc "Show test old"
  task :test do
    system "date"
  end

  desc "Live server for development"
  task :serve do
    cmd = "bundle exec middleman server"
    log cmd
    system cmd
  end
end

namespace :site do
  desc "Generate the Site"
  task :generate do
    cmd = "bundle exec middleman build"
    log cmd
    system cmd
    system "echo mesa-verde-condo.com > out/CNAME"
    system "cp out/index.html out/cl.html"
    system "cp out/index.html out/mp.html"
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

namespace :cl do
  desc "Pull old from CL"
  task :pull do
    require_relative './lib/cl_pull'
    include ClPull
    execute
  end

  desc "Generate HTML page from CL old"
  task :generate do
    require_relative './lib/cl_generate'
    include ClGenerate
    write_history
    write_current
  end
end

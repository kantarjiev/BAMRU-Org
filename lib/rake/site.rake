namespace :site do
  desc "Build the Site"
  task :build do
    cmd = "bundle exec middleman build"
    log cmd
    system cmd
    system "echo bamru.org > out/CNAME"
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
    `cp -r .gcal_keys /tmp` if Dir.exist?('./gcal_keys')
    script.each_line do |line|
      cleanline = line.chomp.strip
      log cleanline
      system cleanline
    end
    dir_tst = (! Dir.exists?('./gcal_keys') && Dir.exists?('/tmp/.gcal_keys'))
    `cp -r /tmp/.gcal_keys .` if dir_tst
  end
end
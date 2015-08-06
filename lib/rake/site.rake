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
    execute script("source files")
  end

  # used by Cron...
  task :deploy_calendar do
    execute script("calendar data")
  end

  def execute(script)
    script.each_line do |line|
      cleanline = line.chomp.strip
      log cleanline
      system cleanline
    end
  end

  def script(label = "")
    timestamp = Time.now.strftime("%y-%m-%d %H:%M")
    msg = "#{label} @ #{timestamp}".strip
    <<-EOF
    rm -rf /tmp/out
    cp -r out /tmp
    git add GcalSync.log
    git commit -m"Update #{msg}"
    git push
    git stash
    git checkout gh-pages
    rm -rf *
    cp -r /tmp/out/* .
    git add .
    git commit -am"Update website #{msg}"
    git push
    git checkout master
    git stash pop
    EOF
  end
end

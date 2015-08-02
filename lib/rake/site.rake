namespace :site do
  desc "Build the Site"
  task :build do
    cmd = "bundle exec middleman build"
    log cmd
    system cmd
    system "echo bamru.org > out/CNAME"
  end

  # used by Cron...
  task :deploy_calendar do
    execute script("calendar data")
  end

  desc "Deploy the Site"
  task :deploy do
    execute script("source files")
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
    msg = "#{label} at #{timestamp}".strip
    <<-EOF
    rm -rf /tmp/out
    cp -r out /tmp
    git add .
    git commit -am"Update master #{msg}"
    git push
    git checkout gh-pages
    rm -rf *
    cp -r /tmp/out/* .
    git add .
    git commit -am"Update website #{msg}"
    git push
    git checkout master
    EOF
  end
end

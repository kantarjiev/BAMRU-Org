namespace :dev do
  desc "Live server for development"
  task :serve do
    cmd = "bundle exec middleman server"
    log cmd
    system cmd
  end

  desc "Run all specs"
  task :spec do
    system "bundle exec rspec -c"
  end

  desc "Start Guard spec runner"
  task :guard do
    system "bundle exec guard"
  end
end

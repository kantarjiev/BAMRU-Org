namespace :dev do
  desc "Live server for development"
  task :serve do
    cmd = "bundle exec middleman server"
    log cmd
    system cmd
  end

  desc "Run all specs"
  task :rspec do
    cmd = "bundle exec rspec -c"
    log cmd
    system cmd
  end

  desc "Start Guard spec runner"
  task :guard do
    cmd = "bundle exec guard"
    log cmd
    system cmd
  end
end

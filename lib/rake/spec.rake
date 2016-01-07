namespace :spec do
  desc "Run all specs"
  task :all do
    cmd = "bundle exec rspec -c"
    log cmd
    system cmd
    exit($?.exitstatus)
  end

  desc "Run unit specs"
  task :unit do
    cmd = "bundle exec rspec -c spec/lib spec/rake"
    log cmd
    system cmd
    exit($?.exitstatus)
  end

  desc "Run system specs"
  task :system do
    cmd = "bundle exec rspec -c spec/system"
    log cmd
    system cmd
    exit($?.exitstatus)
  end

  desc "Start Guard spec runner"
  task :guard do
    cmd = "bundle exec guard"
    log cmd
    system cmd
  end
end

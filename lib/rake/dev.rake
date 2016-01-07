namespace :dev do
  desc "Live server for development"
  task :serve do
    cmd = "bundle exec middleman server"
    log cmd
    system cmd
  end
end

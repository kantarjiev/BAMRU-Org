namespace :total do

  cmd_bnet = %w(data:bnet:download data:bnet:refine)
  cmd_gcal = %w(data:gcal:download data:gcal:refine data:gcal:sync)
  cmd_site = %w(site:build)

  dependencies = cmd_bnet + cmd_gcal + cmd_site

  desc "Resync all data, Rebuild the site"
  task :rebuild => dependencies do
    log "finish total rebuild"
  end
end

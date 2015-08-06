namespace :total do

  bnet_tasks = %w(data:bnet:download data:bnet:refine)
  gcal_tasks = %w(data:gcal:download data:gcal:refine data:gcal:sync)
  site_tasks = %w(site:build)

  sync_deps  = bnet_tasks + gcal_tasks

  desc "Resync all data"
  task :resync => sync_deps do
    log "finish total resync"
  end

  desc "Resync all data, Rebuild the site"
  task :rebuild => sync_deps + site_tasks do
    log "finish total rebuild"
  end
end

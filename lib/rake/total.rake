namespace :total do

  bnet_tasks = %w(data:bnet:download data:bnet:refine)
  gcal_tasks = %w(data:gcal:download data:gcal:refine data:gcal:sync)
  site_tasks = %w(site:build)

  sync_dependencies  = bnet_tasks + gcal_tasks
  build_dependencies = sync_dependencies + site_tasks

  desc "Resync all data"
  task :resync => sync_dependencies do
    log "finish total resync"
  end

  desc "Resync all data, Rebuild the site"
  task :rebuild => build_dependencies do
    log "finish total rebuild"
  end
end

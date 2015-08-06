namespace :total do

  cmd_bnet = %w(data:bnet:download data:bnet:refine)
  cmd_gcal = %w(data:gcal:download data:gcal:refine data:gcal:sync)
  cmd_site = %w(site:build site:deploy_calendar)

  dependencies = cmd_bnet + cmd_gcal + cmd_site

  desc "Re-Sync all data, Rebuild and Redeploy the site"
  task :rebuild => dependencies do
    log "total rebuild is finished"
  end
end

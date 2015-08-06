namespace :total do

  cmd_bnet = %w(data:bnet:download data:bnet:refine)
  cmd_gcal = %w(data:gcal:download data:gcal:refine data:gcal:sync)
  cmd_site = %w(site:build site:deploy_calendar)

  dependencies = cmd_bnet + cmd_gcal + cmd_site

  desc "Re-Sync all data, Rebuild and Redeploy the site"
  task :rebuild => dependencies do
    log "finish total rebuild"
  end

  task :gcal_sync_log_rotate do
    timestamp = Time.now.strftime("%y-%m-%d %H:%M")
    log "rotate GcalSync.log"
    # I don't care about preserving the old data...
    File.open(GCAL_SYNC_LOG, 'w') {|f| f.puts "LOG RESET AT #{timestamp}"}
  end
end

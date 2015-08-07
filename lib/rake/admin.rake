namespace :admin do
  task :log_rotate do
    timestamp = Time.now.strftime("%y-%m-%d %H:%M")
    log "rotate log files"
    # don't care about preserving the old data...
    File.open(GCAL_SYNC_LOG, 'w') {|f| f.puts "LOG RESET AT #{timestamp}"}
    File.open(CRON_LOG, 'w')      {|f| f.puts "LOG RESET AT #{timestamp}"}
  end
end

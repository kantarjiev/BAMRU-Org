namespace :admin do
  task :gcal_sync_log_rotate do
    timestamp = Time.now.strftime("%y-%m-%d %H:%M")
    log "rotate GcalSync.log"
    # I don't care about preserving the old data...
    File.open(GCAL_SYNC_LOG, 'w') {|f| f.puts "LOG RESET AT #{timestamp}"}
  end
end

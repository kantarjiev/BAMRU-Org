require_relative "./base"
require_relative "./gcal_client"
require_relative './rake/loggers'

class GcalSync

  extend Rake::Loggers

  # ----- support methods -----
  def client
    @gcal_client ||= GcalClient.new
  end

  # ----- list of events to be created/deleted -----

  def pending_create
    @pending_create ||= (BNET_STORE.all.keys - GCAL_STORE.all.keys)
  end

  def pending_delete
    @pending_delete ||= (GCAL_STORE.all.keys - BNET_STORE.all.keys)
  end

  # ------ create and delete individual events -----

  def create(event)
    return if event.kind == "operation"
    client.create_event(event)
  end

  def delete(id)
    client.delete_event(id)
  end

  # ----- create / delete pending items -----

  def create_pending
    num_events = pending_create.length
    log "creating #{num_events} events"
    pending_create.each do |evid|
      result = create(BNET_STORE.all[evid])
      log_if_error(result)
      print '.'.green
    end
    puts ' ' unless num_events == 0
  end

  def delete_pending
    num_events = pending_delete.length
    log "deleting #{num_events} events"
    pending_delete.each do |evid|
      result = delete(GCAL_STORE.all[evid].gcal_id)
      log_if_error(result)
      print '.'.green
    end
    puts ' ' unless num_events == 0
  end

  # ----- sync everything -----

  def sync
    delete_pending
    create_pending
  end

  private

  def log_if_error(result)
    body = result.response.body
    puts body.red if body.match(/error/)
  end
end
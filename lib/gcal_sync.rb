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
    log "creating #{pending_create.length} events"
    pending_create.each do |evid|
      result = create(BNET_STORE.all[evid])
      puts result.response.body
      print '.'.green
    end
    puts ' '
  end

  def delete_pending
    log "deleting #{pending_delete.length} events"
    pending_delete.each do |evid|
      print '.'.green
      delete(GCAL_STORE.all[evid].gcal_id)
    end
    puts ' '
  end

  # ----- sync everything -----

  def sync
    delete_pending
    create_pending
  end
end
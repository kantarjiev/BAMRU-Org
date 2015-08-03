require_relative "../base"
require_relative "../rake/loggers"
require_relative "./client"

class Gcal
  class Sync

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
      return event.kind if event.kind == "operation"
      client.create_event(event) unless READONLY
    end

    def delete(id,event)
      client.delete_event(id,event) unless READONLY
    end

    # ----- create / delete pending items -----

    def create_events(event_keys)
      num_events = 0
      event_keys.each do |event_key|
        print '.'.green
        error = create(BNET_STORE.all[event_key])
        num_events += 1 unless error
      end
      puts ' ' unless event_keys.length == 0
      log "Created #{num_events} events"
    end

    def delete_events(event_keys)
      num_events = 0
      event_keys.each do |evid|
        print '.'.green
        error = delete(GCAL_STORE.all[evid].gcal_id, GCAL_STORE.all[evid])
        num_events += 1 unless error
      end
      puts ' ' unless event_keys.length == 0
      log "Removed #{num_events} events"
    end

    # ----- sync everything -----

    def sync
      delete_events(pending_delete)
      create_events(pending_create)
    end

    # ----- delete everything -----

    def delete_all
      delete_events(GCAL_STORE.all.keys)
    end
  end
end

require_relative "./base"
require_relative "./gcal_client"

class GcalSync

  # ----- support methods -----
  def client
    @gcal_client ||= GcalClient.new
  end

  # ----- list of events to be created/deleted -----

  def pending_delete
    GCAL_STORE.all.keys - BNET_STORE.all.keys
  end

  def pending_create
    BNET_STORE.all.keys - GCAL_STORE.all.keys
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
    pending_create.each { |evid| create(BNET_STORE.all[evid]) }
  end

  def delete_pending
    pending_delete.each {|evid| delete(GCAL_STORE.all[evid].gcal_id)}
  end

  # # ----- delete all -----
  #
  # def gcal_delete_all
  #   service = authenticate_and_return_gcal_service
  #   cal     = service.calendars.first
  #   cal.events.each do |event|
  #     puts "Deleting #{event.title}"
  #     event.delete
  #   end
  #   "OK"
  # end
  #
  # def add_all_current_actions_to_gcal
  #   service = authenticate_and_return_gcal_service
  #   get_current_actions_from_database.each do |action|
  #     if action.kind != "operation"
  #       puts "Adding #{action.title} (#{action.id})"
  #       event = Event.new(service)
  #       save_event_to_gcal(service, event, action)
  #     end
  #   end
  #   "OK"
  # end
  #
  # def sync
  #   2.times { delete_all_gcal_events }
  #   add_all_current_actions_to_gcal
  # end
  #
  # def create_event(action)
  #   return if action.kind == "operation"
  #   service = authenticate_and_return_gcal_service
  #   event   = Event.new(service)
  #   puts "Creating #{action.id}"
  #   save_event_to_gcal(service, event, action)
  # end
  #
  # def update_event(action)
  #   return if action.kind == "operation"
  #   delete_event(action.id)
  #   create_event(action)
  # end

  private


end
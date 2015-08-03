require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'
require 'json'
require 'tzinfo'
require_relative "./base"
require_relative './rake/loggers'

class GcalClient
  extend Rake::Loggers

  raise "No Gcal credentials" unless File.exists?(CLIENT_SECRET)

  # ----- instance methods -----

  def initialize
    @client = Google::APIClient.new(:application_name => APPLICATION_NAME)
    @client.authorization = authorize
    @calendar_api ||= @client.discovered_api('calendar', 'v3')
  end

  def list_events
    results = @client.execute!(
                              :api_method => @calendar_api.events.list,
                              :parameters => {
                                :calendarId => 'primary',
                                :maxResults => 2500,  #cst document in base.rb
                                :singleEvents => true,
                                :orderBy => 'startTime' })

    if VERBOSE
      puts "GCal Events:"
      puts "No events found" if results.data.items.empty?
      results.data.items.each do |event|
        start = event.start.date || event.start.date_time
        puts "- #{event.summary} (#{start})"
      end
    end

    results.data.items
    
  end

  def create_event(event)
    event_opts = {
      'summary'     => event.title,
      'description' => event.description,
      'location'    => event.location,
      'start'       => start_for(event),
      'end'         => end_for(event),
    }

    #cst: improve error handling? what's the right behavior 'execute!' or 'execute'
    result = @client.execute(
                              :api_method => @calendar_api.events.insert,
                              :parameters => {
                                'calendarId' => 'primary'},
                              :body_object => event_opts)

    error = result.data.kind != "calendar#event"
    if VERBOSE
      puts "Event created: #{event.title} [#{event.start}]"#c if result.body == ""
    end

    error
  end

  def delete_event(google_event_id, event)
    result = @client.execute(:api_method => @calendar_api.events.delete,
                             :parameters => {
                               'calendarId' => 'primary',
                               'eventId' => google_event_id})

    if result.body == ""
      puts "Event deleted: #{event.title} [#{event.start}] #{google_event_id}" if VERBOSE
      error = nil
    else
      error = JSON.parse(result.response.body)["error"]["message"]
      puts "Delete error: #{event.title} [#{event.start}] #{error}" if VERBOSE
    end

    error
  end

  private

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization request via InstalledAppFlow.
  # If authorization is required, the user's default browser will be launched
  # to approve the request.
  #
  # @return [Signet::OAuth2::Client] OAuth2 credentials
  def authorize
    
    FileUtils.mkdir_p(File.dirname(CREDENTIAL))

    file_store = Google::APIClient::FileStore.new(CREDENTIAL)
    storage = Google::APIClient::Storage.new(file_store)
    auth = storage.authorize
    
    if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
      app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRET)
      flow = Google::APIClient::InstalledAppFlow.new({
                        :client_id => app_info.client_id,
                        :client_secret => app_info.client_secret,
                        :scope => SCOPE})
      auth = flow.authorize(storage)
      puts "Credentials saved to #{CREDENTIAL}" unless auth.nil?
    end
    auth
  end

  # ----- date utilities -----
  # FIXME: These seem like a hack, can we fix BAMRU.net to return start/end times for meetings

  def start_for(event)
    if event.kind == 'meeting'
      {"dateTime" => "#{event.start}T19:30:00-#{offset_for(event.start)}:00"}
    else
      {"date" => event.start}
    end
  end

  def end_for(event)
    fin_date = event.finish.blank? ? event.start : event.finish
    if event.kind == 'meeting'
      {"dateTime" => "#{fin_date}T21:30:00-#{offset_for(fin_date)}:00"}
    else
      # Gcal all-day events are EXCLUSIVE of the end-date
      # solution is to add one day to the end-date
      lcl_date = Time.parse(fin_date) + 1.day
      {"date" => lcl_date.strftime("%Y-%m-%d")}
    end
  end

  def offset_for(date)
    @tz ||= TZInfo::Timezone.get('America/Los_Angeles')
    @tz.local_to_utc(Time.parse(date)).to_s.match(/ (\d\d)/)[1]
  end

end

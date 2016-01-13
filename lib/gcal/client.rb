require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'
require 'json'
require 'tzinfo'

require_relative "../base"
require_relative "../rake/loggers"
require_relative "./log"

class Gcal
  class Client
    extend Rake::Loggers
    include Gcal::Log

    raise "No GCal credentials" unless File.exists?(CLIENT_SECRET)

    # ----- instance methods -----

    def initialize
      @client = Google::APIClient.new(:application_name => APPLICATION_NAME)
      @client.authorization = authorize
      @calendar_api ||= @client.discovered_api('calendar', 'v3')
    end

    def list_events
      args = {
        :api_method => @calendar_api.events.list,
        :parameters => {
          :calendarId   => 'primary',
          :maxResults   => 2500,             #cst document in base.rb, add error check
          :singleEvents => true,
          :orderBy      => 'startTime'
        }
      }
      results = @client.execute!(args)
      if VERBOSE_PLUS
        puts "GCal Events:"
        puts "No events found" if results.data.items.empty?
        results.data.items.each do |g_event|
          start = g_event.start.date || g_event.start.date_time
          puts "- #{g_event.summary} (#{start})"
        end
      end
      results.data.items
    end

    def create_event(event)
      event_opts = {
        'summary'     => event.title,
        'description' => event.gcal_description,
        'location'    => event.gcal_location,
        'start'       => start_for(event),
        'end'         => end_for(event),
      }

      result = @client.execute(
        :api_method => @calendar_api.events.insert,
        :parameters => {
          'calendarId' => 'primary'},
        :body_object => event_opts)

      if result.status == 200
        log_create(event)
        error_msg = nil
      else
        error_msg = JSON.parse(result.response.body)["error"]["message"]
        log_error('CREATE', event, error_msg)
      end

      error_msg
    end


    def delete_event(google_event_id, event)
      result = @client.execute(:api_method => @calendar_api.events.delete,
                               :parameters => {
                                 'calendarId' => 'primary',
                                 'eventId' => google_event_id})

      if result.status == 204
        log_delete(event, google_event_id)
        error_msg = nil
      else
        error_msg = JSON.parse(result.response.body)["error"]["message"]
        log_error('DELETE', event, error_msg)
      end

      error_msg
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

    def start_for(event)
      if event.begin_time.blank?
        {"date" => event.begin_date}
      else
        {"dateTime" => "#{event.begin_date}T#{event.begin_time}"}
      end
    end

    def end_for(event)
      if event.finish_time.blank?
        # GCal all-day events are EXCLUSIVE of the end date
        # solution is to add one day to the end-date
        lcl_date = Time.parse(event.finish_date) + 1.day
        {"date" => lcl_date.strftime("%Y-%m-%d")}
      else
        {"dateTime" => "#{event.finish_date}T#{event.finish_time}"}
      end
    end

  end
end

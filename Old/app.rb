base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
require 'yaml'
require 'uri'
require 'net/http'
require 'daemons'
require 'rack-flash'
require 'sinatra/cache_assets'
require base_dir + '/lib/env_settings'
require base_dir + '/config/environment'

class BamruApp < Sinatra::Base
  helpers Sinatra::AppHelpers

  # ----- CALENDAR PAGES -----

  get '/calendar' do
    # establish the start and finish range
    @start  = Event.date_parse(select_start_date)
    @finish = Event.date_parse(select_finish_date)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start]  = @start
    session[:finish] = @finish
  end

  get '/calendar2' do
    # establish the start and finish range
    puts "ACTION CALENDAR 2"
    @start  = Xevent.date_parse(select_start_date)
    @finish = Xevent.date_parse(select_finish_date)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start]  = @start
    session[:finish] = @finish
    # setup the display variables
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = erb GUEST_POLICY, :layout => false
    @left_txt  = quote
    erb :calendar2
  end

  get '/calendar.ical' do
    expires 60, :public, :must_revalidate
    last_modified last_db_update_date
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :calendar_ical, :layout => false
  end

  get '/calendar.csv' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :calendar_csv, :layout => false
  end

  get '/calendar.gcal' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    @title     = "BAMRU's Google Calendar"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = quote
    erb :calendar_gcal
  end

  # ----- OPERATIONS PAGES -----

  get '/operations' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Event.date_parse(select_start_operation)
    @finish = Event.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    @title     = "BAMRU Operations"
    @hdr_img   = "images/glacier.jpg"
    range      = "range=#{@start.to_label}_#{@finish.to_label}"
    @filename  = "operations#{(rand * 10000).round}.kml?#{range}"
    @right_nav = quote
    @right_txt = erb BIG_MAP, :layout => false
    erb :operations
  end

  get '/operations2' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Xevent.date_parse(select_start_operation)
    @finish = Xevent.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    @title     = "BAMRU Operations"
    @hdr_img   = "images/glacier.jpg"
    range      = "range=#{@start.to_label}_#{@finish.to_label}"
    @filename  = "op2_#{(rand * 10000).round}.kml?#{range}"
    @right_nav = quote
    @right_txt = erb BIG_MAP, :layout => false
    erb :operations
  end

  get "/operations*.kml*" do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Event.date_parse(select_start_operation)
    @finish = Event.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    response["Content-Type"] = "text/plain"
    @operations = Event.operations.between(@start, @finish)
    erb :operations_kml, :layout => false
  end

  get "/op2_*.kml*" do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Xevent.date_parse(select_start_operation)
    @finish = Xevent.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    response["Content-Type"] = "text/plain"
    @operations = Xevent.operations.between(@start, @finish)
    erb :operations_kml, :layout => false
  end

  # ----- LANDING PAGES -----

  get '/truck2013' do
    @title     = "BAMRU Truck Campaign"
    @hdr_img   = "images/approach.jpg"
    @right_nav = erb(:thermometer, :layout => false)
    @left_txt  = quote
    erb :truck2013
  end

  get '/sponsors' do
    @title     = "BAMRU Sponsors"
    @hdr_img   = "images/approach.jpg"
    @right_nav = quote
    erb :sponsors
  end

  get '/projects' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Web Projects"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :web_projects
  end

  # ----- CSV Resync -----

  get('/csv_resync') do
    require 'csv'
    require 'open-uri'
    csv_text = open("http://bamru.net/public/calendar.csv").read
    array    = CSV.parse(csv_text)
    headers  = array.shift
    Event.delete_all
    array.each { |event| Event.create(Hash[*headers.zip(event).flatten]) }
    "OK"
  end

  # ----- Error handling -----

  # for testing
  get '/generror' do
    xx = nil.quote
    "not working"
  end

  error do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    status 200
    err = env['sinatra.error']
    @error_name  = err.respond_to?(:name) ? err.name : "Error"
    @error_mesg  = err.respond_to?(:name) ? err.message : "An error occurred"
    unless ENV['RACK_ENV'] == 'test'
      puts '*' * 80, "ERROR", Time.now, @error_name, @error_mesg, '*' * 80
    end
    message = "error_name:#{@error_name}"
    Nq.alert_mail(message)
    erb :error
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    status 200
    erb :not_found
  end

end

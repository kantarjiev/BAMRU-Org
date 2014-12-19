require 'sinatra/base'
require 'time'
require 'rack'

module Sinatra
  module AppHelpers



    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def background(&block)
      Process.fork do
        Process.fork do
          Daemons.call &block
        end
        exit
      end
    end

    def authorized?
      return true if ENV['ADMIN_LOGGED_IN'] == 'true'
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? &&
              @auth.basic? &&
              @auth.credentials &&
              @auth.credentials == ['admin', 'admin']
    end

    def current_server
      "http://#{request.env["HTTP_HOST"]}"
    end

    def current_page
      request.path_info
    end

    def select_start_date
      params[:start]  || session[:start] ||  Event.default_start
    end

    def select_finish_date
      params[:finish] || session[:finish] || Event.default_end
    end

    def select_start_operation
      range = params[:range].nil? ? nil : params[:range].split('_').first
      range || params[:start]  || session[:start_operation] ||  Event.default_start_operation
    end

    def select_finish_operation
      range = params[:range].nil? ? nil : params[:range].split('_').last
      range || params[:finish] || session[:finish_operation] || Event.default_end_operation
    end

    def number_of(kind = "")
      return Event.count if kind.blank?
      Event.kind(kind).count
    end

    def last_modification_date(file_spec = nil)
      file_spec ||= %w(app* views/*)
      Dir[*file_spec].map {|f| File.ctime(f)}.max
    end

    def last_modification(file_spec = nil)
      last_modification_date.strftime("%a %b %d - %H:%M")
    end

    def last_restart
      File.ctime(BASE_DIR + "/tmp/restart.txt").strftime("%a %b %d - %H:%M")
    end

    def record_display(event)
      return if event.nil?
      "<b>#{event.start}</b> (<a href='/admin_edit/#{event.id}'>#{event.title[0..15]}...</a>)"
    end

    def oldest_record
      record_display Event.order('start').first
    end

    def newest_record
      record_display Event.order('start').last
    end

    def last_db_update_date
      rec = Event.order('updated_at').last
      return if rec.nil?
      rec.updated_at
    end

    def last_update
      rec = Event.order('updated_at').last
      return if rec.nil?
      "<b>#{rec.updated_at.strftime("%a %b %d - %H:%M")}</b> (<a href='/admin_edit/#{rec.id}'>#{rec.title[0..7]}...</a>)"
    end

    def link_url(url)
      "<a href='#{url}'>#{url}</a>"
    end




    def event_table(events)
      output = ""
      alt   = true
      first = true
      events.each do |m|
        color = alt ? "#EEEEEE" : "#FFFFFF"
        output << event_row(m, color, first)
        first = false
        alt = ! alt
      end
      output
    end

    def event_row(event, color='#EEEEEE', first = false)
      <<-ERB
      <tr bgcolor="#{color}">
        <td valign="top" class=summary>&nbsp;
             #{event.title}
        </td>
        <td>
             <span class=copy>#{event.location}</span>
        </td>
        <td valign="top" NOWRAP class=summary>
          #{event.date_display(first)}
        </td>
        <td valign="top" NOWRAP class=summary>
          #{format_leaders(event)}
        </td>
        <td class=ac>
          <nobr>#{event_links(event.id)}</nobr>
        </td>
      </tr>
      ERB
    end

    def event_links(eid)
      x1 = [event_show_link(eid)]
      x2 = [event_copy_link(eid), event_edit_link(eid), event_delete_link(eid)]
      output = x1 + x2
      output.join(' | ')
    end

    def csv_file_data(file_param)
      file_params[:tempfile].read
    end

    def set_flash_notice(msg)
      flash[:notice] ? flash[:notice] << msg : flash[:notice] = msg
    end

    def get_flash_notice
      var = flash[:notice]; flash[:notice] = nil
      "<div class='notice'>#{var}</div>" unless var.nil?
    end

    def set_flash_error(msg)
      flash[:error] ? flash[:error] << msg : flash[:error] = msg
    end

    def get_flash_error
      var = flash[:error]; flash[:error] = nil
      "<div class='error'>#{var}</div>" unless var.nil?
    end

    def error_text(hash)
      hash.map {|k,v| "<b>#{k}:</b> #{v}"}.join("<br/>")
    end

    def event_range_select(start, finish, direction, scope = Event)
      if direction == "start"
        opt  = start.to_label
      else
        opt  = finish.to_label
      end
      opts = scope.range_array(opt)
      output = "<select name='#{direction}'>#{opt}"
      output << opts.map do |x|
        sel = x == opt ? " SELECTED" : ""
        "<option value='#{x}'#{sel}>#{x}"
      end.join unless opts.nil?
      output << "</select>"
      output
    end

    def select_helper(action = nil)
      vals = %w(meeting training operation community)
      vals.map do |i|
        opt = i == action.kind ? " selected" : "" unless action.nil?
        "<option value='#{i}'#{opt}>#{i.capitalize}</option>"
      end.join(' ')
    end

    def event_show_link(eventid)
      "<a href='/admin_show/#{eventid}'>show</a>"
    end

    def event_copy_link(eventid)
      "<a href='/admin_copy/#{eventid}'>copy</a>"
    end

    def event_edit_link(eventid)
      "<a href='/admin_edit/#{eventid}'>edit</a>"
    end

    def event_delete_link(eventid)
      "<a href='/admin_delete/#{eventid}'>delete</a>"
    end

    def admin_link(target, label)
      link = "<a href='#{target}'>#{label}</a>"
      target == current_page ? label : link
    end

    def link_to(label, target)
      "<a href='#{target}'>#{label}</a>"
    end

    def admin_nav
      opt = [
              ['/admin_home',          'Admin Home'  ],
              ['/admin_events',        'Events'      ],
              ['/admin_create',        'Create Event']
      ]

      opt.map {|i| admin_link(i.first, i.last)}.join(' | ')
      ""
    end

    def admin_sub_nav(array)
      hdr = array.first
      ftr = array[1..-1]
      first_link = admin_link(hdr.first, hdr.last)
      last_links = ftr.map {|i| admin_link(i.first, i.last)}.join(', ')
      "#{first_link} (#{last_links})"
    end

    def admin_cal_nav
      opt = [
              ['/calendar',      'calendar'     ],
              ['/calendar.gcal', 'gcal'],
              ['/calendar.csv',  'csv' ]
      ]
      admin_sub_nav(opt)
    end

    def admin_ops_nav
      opt = [
              ['/operations',      'operations'          ],
              ['/operations.kml',  'kml'      ]
      ]
      admin_sub_nav(opt)
    end

    def admin_nav_footer
      opt1 = [
              ['/admin_data',     'Data'      ]
      ]
      r1 = opt1.map {|i| admin_link(i.first, i.last)}.join(' | ')
      "<hr>#{r1}"
    end

    def geo_start(action)
      if action.lat.blank? || action.lon.blank?
        "startAddress: 'Redwood City, California',"
      else
        "startPositionLat: #{action.lat}, startPositionLng: #{action.lon},"
      end
    end

  end

  helpers AppHelpers

end


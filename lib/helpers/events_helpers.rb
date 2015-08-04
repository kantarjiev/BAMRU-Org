require          "active_support"
require_relative "../base"
require_relative "../event/event"
require_relative "../event/store"
require_relative "../helpers/date_range"

module EventsHelpers

  # ----- display functions -----
  def range_start
    DateRange.start_month
  end

  def range_finish
    DateRange.finish_month
  end

  # ----- scopes -----

  def event_meetings
    events.meetings
  end

  def event_trainings
    events.trainings
  end

  def event_others
    events.others
  end

  # ----- event rendering -----

  def calendar_table(events, link="")
    alt = false
    first = true
    events.values.map do |e|
      alt = ! alt
      color = alt ? "#EEEEE" : "#FFFFF"
      val = calendar_row(e, link, color, first)
      first = false
      val
    end.join
  end

  def detail_table(events)
    events.values.map {|e| detail_row(e)}.join
  end

  private

  def events
    @events_obj ||= Event::Store.new(BNET_DATA_YAML_FILE)
  end

  def calendar_row(event, link = '', color='#EEEEEE', first = false)
    link = event.id if link.empty?
    <<-ERB
      <tr bgcolor="#{color}">
        <td valign="top" class=summary>&nbsp;
             <a href="##{link}" class=summary>#{event.title}</a>
             <span class=copy>#{event.location}</span>
        </td>
        <td valign="top" NOWRAP class=summary>
          #{event_display(event)}
        </td>
        <td valign="top" NOWRAP class=summary>
          #{format_leaders(event)}
        </td>
      </tr>
    ERB
  end

  def detail_row(event)
    <<-ERB
      <p/>
      <span class="caps"><a id='#{event.id}'></a><span class="nav3">
      #{event.title}</span></span><br/>
      <span class="news10"> <font color="#888888">#{event.location}<br>
      #{date_display(event)}<br>      Leaders: #{event.leaders}<br><br></font></span>
      #{clean_description(event)}<br>
      <font class="caps"><img src="images/assets/dots.gif" width="134" height="10"></font></p>
    ERB
  end

  def event_display(event)
    start = Time.parse(event.start)
    year  = first_in_year?(event) ? ", #{start.strftime('%Y')}" : ""
    multi = event.start != event.finish && event.finish.present?
    fstr  = multi ? "-#{event.finish.split('-').last}" : ""
    "#{start.strftime('%b')} #{start.strftime('%d')}#{fstr}#{year}"
  end

  def first_in_year?(event)
    get_year = ->(ev) { ev.start.split('-').first }
    prior = event.prior
    return true if prior.blank?
    get_year.call(event) != get_year.call(prior)
  end

  def format_leaders(event)
    event.leaders.split(',').first.split(' ').last.split('/').first
  end

  def clean_description(event)
    event.description.gsub(/[\@\&\:\/\%\=\&]/,' ').gsub("\n", ' ')
  end

  def date_display(event)
    start  = event.start
    finish = event.finish
    return "#{start} - #{finish}" if finish != start && finish.present?
    start
  end
end

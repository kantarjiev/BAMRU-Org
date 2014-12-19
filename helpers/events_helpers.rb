require "active_support"
require "lib/events"

module EventsHelpers

  def range_start
    Events.range_start_month
  end

  def range_end
    Events.range_end_month
  end

  def event_meetings
    events.meetings
  end

  def event_trainings
    events.trainings
  end

  def event_others
    events.others
  end

  def event_display(event)
    start = Time.parse(event["start"])
    year  = first_in_year?(event) ? ", #{start.strftime('%Y')}" : ""
    "#{start.strftime('%b')} #{start.strftime('%d')}#{year}"
  end

  def first_in_year?(event)
    get_year = ->(ev) { ev["start"].split('-').first }
    prior = event["prior"]
    return true if prior.blank?
    get_year.call(event) != get_year.call(prior)
  end

  def format_leaders(event)
    event["leaders"].split(',').first.split(' ').last.split('/').first
  end

  def calendar_table(events, link="")
    alt = false
    first = true
    events.map do |e|
      alt = ! alt
      color = alt ? "#EEEEE" : "#FFFFF"
      val = calendar_row(e, link, color, first)
      first = false
      val
    end.join
  end

  def calendar_row(event, link = '', color='#EEEEEE', first = false)
    link = event["id"] if link.empty?
    <<-ERB
      <tr bgcolor="#{color}">
        <td valign="top" class=summary>&nbsp;
             <a href="##{link}" class=summary>#{event["title"]}</a>
             <span class=copy>#{event["location"]}</span>
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

  def detail_table(events)
    events.map {|e| detail_row(e)}.join
  end

  def detail_row(event)
    <<-ERB
      <p/>
      <span class="caps"><a id='#{event["id"]}'></a><span class="nav3">
      #{event["title"]}</span></span><br/>
      <span class="news10"> <font color="#888888">#{event["location"]}<br>
      #{date_display(event)}<br>      Leaders: #{event["leaders"]}<br><br></font></span>
      #{event["description"]}<br>
      <font class="caps"><img src="images/assets/dots.gif" width="134" height="10"></font></p>
    ERB
  end

  def date_display(event)
    start  = event["start"]
    finish = event["finish"]
    return "#{start} - #{finish}" if finish != start && finish.present?
    start
  end

  private

  def events
    @events_obj ||= Events.new
  end
end
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
          #{event["start"]}
        </td>
        <td valign="top" NOWRAP class=summary>
          #{"asdf"}
        </td>
      </tr>
    ERB
  end

  private

  def events
    @events_obj ||= Events.new
  end
end
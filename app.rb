require 'json'
require 'sinatra'
require 'icalendar'

get '/tnct-adv' do
  calendar = Icalendar::Calendar.new
  calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", "苫小牧高専アドベントカレンダー2017カレンダー")
  calendar.timezone do |t|
    t.tzid = 'Asia/Tokyo'
    t.standard do |s|
      s.tzoffsetfrom = '+0900'
      s.tzoffsetto   = '+0900'
      s.tzname       = 'JST'
      s.dtstart      = '19700101T000000'
    end
  end

  json = JSON.parse(File.read('./tomakomai-kosen-adv-2017.json'))
  json['entries'].each do |entry|
    calendar.event do |e|
      e.dtstart = Icalendar::Values::Date.new(Date.parse(entry['date']))
      e.summary = entry['title']
      e.description = "#{entry['title']}\n#{entry['url']}"
    end
  end
  calendar.publish

  content_type 'text/calendar'
  calendar.to_ical
end

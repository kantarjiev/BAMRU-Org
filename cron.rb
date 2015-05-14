# Use this file to easily define all of your cron jobs.
#
# to generate cronfile : `whenever -f cron.rb --update-crontab`
# to clear cronfile    : `whenever -f cron.rb --clear-crontab`
# for help on whenever : `whenever -h`
# to see cron settings : `crontab -l`
# to edit the cronfile : `crontab -l`
#
# Learn more:
# - http://github.com/javan/whenever  | cron processor
# - http://en.wikipedia.org/wiki/Cron | cron instructions

set :output, "/tmp/bamru_org.log"

cmd = "data:bnet:download data:bnet:refine site:build site:deploy"

every 1.day, at: '5:00 am' do
  rake cmd
end

every 1.day, at: '11:00 am' do
  rake cmd
end

every 1.day, at: '5:00 pm' do
  rake cmd
end

every 1.day, at: '11:00 pm' do
  rake cmd
end


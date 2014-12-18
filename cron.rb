# Use this file to easily define all of your cron jobs.
#
# to generate cronfile : `whenever -f cron.rb --update-crontab`
# for help on whenever : `whenever -h`
# to see cron settings : `crontab -l`
#
# Learn more:
# - http://github.com/javan/whenever  | cron processor
# - http://en.wikipedia.org/wiki/Cron | cron instructions

set :output, "/tmp/cron_mvcondo.log"

every 1.day, at: '5:00 am' do
  rake "cl:pull cl:generate site:generate site:deploy"
end


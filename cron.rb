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
#

require "./lib/base"

set :output, CRON_LOG                # log file output
set :environment_variable, "MM_ENV"  # sets MM_ENV to 'production'

cmd = "total:rebuild site:deploy_calendar"

every 10.minutes do
  rake cmd
end

every 1.week do
  rake 'admin:log_rotate'
end


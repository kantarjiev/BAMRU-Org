# Use this file to define cron jobs on your development system.
#
# to generate cronfile : `whenever -f crondev.rb --update-crontab`
# to clear cronfile    : `whenever -f crondev.rb --clear-crontab`
# for help on whenever : `whenever -h`
# to see cron settings : `crontab -l`
# to edit the cronfile : `crontab -e`
#
# Learn more:
# - http://github.com/javan/whenever  | cron processor
# - http://en.wikipedia.org/wiki/Cron | cron instructions
#

require "./lib/base"

set :output, CRON_LOG                # log file output
set :environment_variable, "MM_ENV"  # sets MM_ENV to 'production'

every 10.minutes do
  rake "total:rebuild site:deploy_calendar" # only runs if data has changed...
end

every 1.week do
  rake "admin:log_rotate"
end


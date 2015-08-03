# Cron

View the [README](../README.md)

## Overview

The `cron` process will auto-update the Google Calendar every evening.

Here are the relevant rake tasks:

    > rake cron:init           # Initialize cron process
    > rake cron:remove         # Remove cron process
    > rake cron:status         # Show cron status

Please coordinate with AndyL before running this on your server.  We would like
to run just one `cron` process to update the production calendar.

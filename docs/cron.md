# Cron

View the [README](../README.md)

## Overview

The `cron` process will auto-update the Google Calendar every evening.

Here are the relevant rake tasks:

    rake cron:init           # Initialize cron process
    rake cron:remove         # Remove cron process
    rake cron:status         # Show cron status

Please coordinate with AndyL before running this locally - we would like to run
just a single `cron` process for our production calendar.

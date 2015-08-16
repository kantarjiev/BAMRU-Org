# Cron

[Index](./index.md)

## Overview

The `cron` process will sync BAMRU.net event data with the Website and Google
Calendar automatically.  The sync process runs every ten minutes.

Here are the relevant rake tasks:

    > rake cron:init           # Initialize cron process
    > rake cron:remove         # Remove cron process
    > rake cron:status         # Show cron status

Please coordinate with AndyL before running this on your server.  It is
important to run just one `cron` process to update the production calendar.

# Integrating with Google Calendar

View the [README](../README.md)

## Overview

BAMRU's event calendar can sync to a live Google calendar.  Gcal update is done
using Google API V3.  Using the Gapi V3 is complicated, but this is the only
tool that lets us do Calendar Sync.

Note: you don't need Gcal integration for basic copy editing!  Nor do you need
Gcal integration to update the HTML calendar on
[BAMRU.org](http://bamru.org/calendar).

## Gcal Production and Test Calendars

BAMRU's production calender is `bamru.calendar@gmail.com`.

BAMRU's test calendar is `bamru.caltest@gmail.com`.

Dozens of people are subscribed to our production calendar.  If you use the
production calendar for development and testing, they will complain!

The passwords for our production and test calendar accounts are on the BAMRU
wiki.  Ask AndyL if you need help.

## Setting up a new Calendar

Setting up a calendar for Gapi V3 access is a complicated mess.

You can find some instructions outlined on the
[Readme](https://github.com/google/google-api-ruby-client) for the RubyGem
that we use for API integration.

### Google API Configuration

1) Go to the Google API Console.  Click `Sign up for a Free Trial`.
You will have to give a CC number, sadly.  But our usage level will be far
below the Paid tier.

2) Create a new project.

3) Visit the project Permissions, and save the Google APIs service account.

4) Go to `APIs & auth > APIs` and enable the `Calendar API`.

5) Go to `APIs & auth > Credentials`

6) Create an `Oauth / Service Account` credential

7) Generate/download a P12 key

### Calendar Configuration

Now - go back to your calendar.

1) Visit `My Calendar > Settings > Share this Calendar`

2) Enter the address you saved above in step 3.

Is your head spinning yet?  We're nearly done...

## The GCAL_KEYS directory

Gapi Credentials are stored in the .gcal_keys directory in the home directory
of the project.  For security, these keys are not loaded into our Git repo.

You will need to gather three items to make it all work:
1. the Calendar ID - get this from "My Calendar > Settings > Calendar Address"
2. an issuer address - a service account from the Google API console
3. a P12 certificate - download from the Google API console

Ask AndyL to send you a private copy of the keys.  Then you can edit the
directory to include your new account information.

Note: to prevent inadvertent deletion of the `gcal_keys` directory, it is backed
up to `~/.gcal_keys` every time you run `rake site:build`.

## Using Gcal Integration

After you have configured `.gcal_keys` you will see these rake tasks:

    rake data:gcal:download  # Download Gcal Data
    rake data:gcal:refine    # Refine Gcal json data to YAML
    rake data:gcal:sync      # Sync all Gcal Data

Reminder: use the `test` account while doing development!

    MM_ENV=test rake data:gcal:download data:gcal:refine data:gcal:sync

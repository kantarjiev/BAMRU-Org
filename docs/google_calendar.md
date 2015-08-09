# Integrating with Google Calendar

[Index](./index.md)

## Overview

BAMRU's event calendar can sync to a live Google calendar.  Gcal update is done
using Google API V3.

Note: you don't need Gcal integration for basic copy editing!  Nor do you need
Gcal integration to update the HTML calendar on
[BAMRU.org](http://bamru.org/calendar).

## Gcal Production and Test Calendars

BAMRU's production calender account is `bamru.calendar@gmail.com`.

BAMRU's test calendar account is `bamru.caltest@gmail.com`.

Dozens of people are subscribed to our production calendar.  If you use the
production calendar for development and testing, they will complain!

The passwords for our production and test calendar accounts are on the BAMRU
wiki.  Ask AndyL or CraigT if you need help.

## Setting up a new Calendar

Setting up a calendar for Gapi V3 access requires 3 things: a project, a secret
and consent.

Enable the Google Calendar API

1) Create a project in the Google Developers Console and enable the Calendar API
(https://console.developers.google.com/project)

2) In the sidebar on the left, select Consent screen. Enter a PRODUCT NAME
(PublishCalendar) if not already set, and click the Save button.

3) In the sidebar on the left, select APIs & auth and then Credentials. In the
new tab that opens, click Create new Client ID.

4) Select the application type Installed application, the installed application
type Other, and click the Create Client ID button.

5) Click the Download JSON button under your new client ID. Move this file to
your working directory ~/.gcal_keys and rename it client_secret.json.  

6) Run 'rake data:gcal:download'.  This will start a browser and ask for
consent.

7) That's it things should be working

A good example for ruby:
https://developers.google.com/google-apps/calendar/quickstart/ruby

## GCAL Keys

Ask AndyL or CraigT to send you a copy of the `gcal_keys` directory.  Then you can edit
the directory to include your new account information.

The Gcal Keys should be stored in your home directory `~/.gcal_keys`

## Using Gcal Integration

After you have configured `~/.gcal_keys` you will see these rake tasks:

    > rake data:gcal:download  # Download Gcal Data
    > rake data:gcal:refine    # Refine Gcal json data to YAML
    > rake data:gcal:sync      # Sync all Gcal Data

Reminder: use the `test` account while doing development!

    > MM_ENV=test rake data:gcal:download data:gcal:refine data:gcal:sync

# BAMRU.org Static Website

## Overview

BAMRU.org is a public-facing website composed of static assets. (html,
css, images, javascript).  The live version of this website is at
http://bamru.org .

Any BAMRU Member or Supporter is welcome to do hands-on editing or programming.
Contact Andy L. for info on current needs.
[Fork](http://help.github.com/articles/fork-a-repo) this repository if you
would like to experiment.

## Editing Workflow

A site generator called [MiddleMan](http://middlemanapp.com) is used
to generate the static assets from page templates.

Templates are in plain-text formats like
[Markdown](http://en.wikipedia.org/wiki/Markdown),
[ERB](http://en.wikipedia.org/wiki/ERuby) and
[Slim](http://slim-lang.com).

The static assets can be served from any webserver.  For convenience
and cost-savings, we use [GitHub Pages](https://pages.github.com) as
the server host.

Copywriting can be done using a browser, or using the free GitHub
software for [Mac][1] or [Windows][2].

The workflow for Designers and Coders generally follows this cycle:

1) Set up the required tools and repositories.  Get access to the
BAMRU.org repo.

2) Clone the repo, make edits and test locally.

3) Upload the finished commits, and publish the edits.

[1]: https://windows.github.com
[2]: https://mac.github.com/

## Programmer Tools and Skills

To update the website programs, you'll need a browser, a github account, Ubuntu
or Mac (or UbuntuVM), CommandLine savvy and Ruby skills.

## More Information

[How to Contribute](./docs/contributing.md)

[About the Development Environment](./docs/dev_environment.md)

[How to be a Copy Editor](./docs/copy_editor.md)

[Integrating with Google Calendar](./docs/google_calendar.md)

[Running Auto-Updates with Cron](./docs/cron.md)

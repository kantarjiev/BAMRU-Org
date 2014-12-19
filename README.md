# BAMRU.org Static Website

## Overview

BAMRU.org is a public-facing website composed of static assets. (html,
css, images, javascript).  A live version of this website is at
http://andyl.github.io/BAMRU-Org/.

Maintaining the website is a team effort with multiple roles.

| Role       | Responsibility                                      |
| ----       | --------------                                      |
| Copywriter | Make textual edits                                  |
| Designer   | Create site styling, edit graphics                  |
| JS Coder   | Client-Side Javascript for interactive components   |
| Ruby Coder | Server-Side Ruby for site generation and automation |

Any BAMRU Member or Supporter is welcome to do hands-on editing.
Contact Andy L. for info on current needs.
[Fork](http://help.github.com/articles/fork-a-repo) this repository if
you would like to experiment.

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

## Required Tools
         
| Tool                                | Required By     |
| ----                                | -----------     |
| Internet connection                 | All             |
| Web Browser                         | All             |
| GitHub Account                      | All             |
| GitHub for [Mac][1] or [Windows][2] | Copywriter      |
| Ubuntu or Mac computer              | Designer, Coder |
| Ruby                                | Designer, Coder |

[1]: https://windows.github.com
[2]: https://mac.github.com/

## Required Skills

| Skill              | Required By     |
| -----              | -----------     |
| English Grammar    | Copywriter      |
| Markdown           | Copywriter      |
| ERB / Slim         | Designer, Coder |
| Middleman          | Designer, Coder |
| Command Line Savvy | Designer, Coder |
| Text Editor Skills | Designer, Coder |
| Git & GitHub       | Designer, Coder |
| CSS                | Designer        |
| Photoshop          | Designer        |
| JavaScript         | JS Coder        |
| CoffeeScript       | JS Coder        |
| ReactJS / Reflux   | JS Coder        |
| Ruby               | Ruby Coder      |

## More Information

[BAMRU.org Development Environment](./docs/dev_environment.md)

[How to be a CopyWriter](./docs/copywrite.md)




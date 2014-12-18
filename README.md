# BAMRU.org Static Pages

## Overview

BAMRU.org is a public-facing website composed of static assets. (html, css, images, javascript).

A site generator called [MiddleMan](http://middlemanapp.com) is used to generate the static assets.

The static assets can be served from any webserver.  For convenience and cost-savings, we use GitHub pages as the server host.

Using MiddleMan, the editing workflow generally follows this cycle:

1) Set up the required tools and repositories.  Get access to the BAMRU.org repo.

2) Clone the repo, make edits and test locally.

3) Upload the finished commits, and publish the edits.

## Who Can Edit

TBD





## Tools and Skills

To be productive, you will the following tools and skills

Tools:

* Ubuntu or Mac computer
* Good internet connection

Required Skills:

* Command Line Savvy
* Text Editor Skills
* Knowledge of Git / GitHub

Nice-To-Have Skills:

* Ruby
* Middleman / Rails
* Slim & Markdown
* CSS
* JavaScript / Coffeescript

## Environment Setup

TBD

## Repo Setup

Before starting, you must have update rights on the repo.

First step is to make sure there is a gh-pages branch which holds the HTML output.

    git clone git@github.com:andyl/BAMRU-Org.git    # clone the repo
    git branches -a                                 # show all branches
    git checkout -b gh-pages origin/gh-pages        # make a local copy of the 'gh-pages' branch

## Support Software

This site depends on Ruby 2.1.5 and the `middleman` gem.

    ruby-install ruby 2.1.2
    cd <dir>/mvcondo
    gem install bundler
    bundle

## Editing and Building the Site

Project input is read from the `source` directory.

To run the generator:

    cd <dir>/mvcondo
    bundle exec middleman build

Project output is written to the `build` directory.

## Deploying the Site

The project is hosted on github pages.  Output HTML is stored on the
`gh-pages` branch.

To deploy:

    cd <dir>/mvcondo
    rm -rf /tmp/output
    cp -r output /tmp
    git checkout gh-pages
    rm -rf .
    cp -r /tmp/output/* .
    git add .
    git commit -am'update website'
    git push
    git checkout master

See `Github Pages` to learn more.

## Rake Tasks

    rake build        # run the build command
    rake deploy       # run the deploy script 

  

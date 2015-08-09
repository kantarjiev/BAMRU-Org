# BAMRU.org Development Environment

[Index](./index.md)

## Development Operating System

This has only been tested on Ubuntu 14.04.  If you are running Mac or Windows,
I recommend that you install & use Vagrant/VirtualBox with an Ubuntu VM. (a
pre-configurated Vagrantfile is provided in this repository...)

## Installation

Install Ruby 1.9.3 on your Ubuntu development machine:

    > sudo apt-get update
    > sudo apt-get upgrade
    > sudo apt-get remove ruby1.8
    > sudo apt-get install ruby1.9.1 ruby1.9.1-dev npm build-essential git

Clone your forked repo to your development machine, then configure your local repo:

    Create a GitHub account.  Go to https://github.com/andyl/BAMRU-Org and fork the repo
    to your github account (fork buttom upper right corner)

    > git clone https://github.com/<your-github-userid>/BAMRU-Org.git  # clone the repo to your dev machine 
    > cd BAMRU-Org                                                     # cd to your local repo directory
    > git branch -a                                                    # show branches - look for `gh-pages`
    > git checkout -b gh-pages origin/gh-pages                         # make a local copy of `gh-pages`
    > git checkout master                                              # checkout the master branch
    > git remote add upstream https://github.com/andyl/BAMRU-Org.git   # add an upstream remote

Install the project Ruby Gems, including MiddleMan: 

    > sudo gem install bundler    # install bundler 
    > bundle install              # install Ruby Gems

All done!  

## Checking your Installation

Here are some diagnostic commands that let you examine and tweak your
development environment:

    > gem list                # shows the list of installed ruby gems
    > which ruby              # shows the path to your `ruby` executable
    > ruby -v                 # shows the current version of ruby
    > git remote -v           # shows the configured git remotes for your repo
    > git branch -a           # shows all git branches in your repository
    > ls ~/.gcal_keys         # have you installed `~/.gcal_keys`?
    > which rake              # shows the path to your `rake` executable
    > rake -T                 # shows a list of rake commands
    > rake dev:rspec          # verify that all regression tests run
    > rake data:bnet:download # verify that you can download Bnet data

## Git Workflow

Step 1: Pull upstream changes into your local repository, to make sure things are in
sync:

    > git pull upstream master

Step 2: Make edits in your local development repository.

Step 3: Pull upstream changes again, to make sure everything is in sync. Repeat
as often as necessary:

    > git pull upstream master

Step 4: Push your changes to your GitHub repo:

    > git push origin master

Step 5: Go to GitHub and create a Pull Request.

## Rake Tasks

The build and deploy tasks have been automated using a Ruby tool called
[Rake](http://en.wikipedia.org/wiki/Rake_%28software%29).

To view all of the Rake tasks, type `rake -T`.

Most important Rake tasks include:

    > rake dev:serve       # run the development server on port 4567
    > rake site:build      # run the build command
    > rake site:deploy     # run the deploy script

## Building the Site

Project input is read from the `src` directory.

To run the generator manually:

    > cd <dir>/BAMRU-Org
    > bundle exec middleman build

Project output is written to the `out` directory.

You can also run `rake site:build`.

## Deploying the Site

The project is hosted using GitHub pages.  Output HTML is stored on the
`gh-pages` branch.

The manual deploy process looks like this:

    > cd <dir>/BAMRU-Org
    > rm -rf /tmp/output
    > cp -r output /tmp
    > git checkout gh-pages
    > rm -rf .
    > cp -r /tmp/output/* .
    > git add .
    > git commit -am'update website'
    > git push
    > git checkout master

You can run all of this in a single command using `rake site:deploy`.  Note
that this command will deploy the site to your own GitHub repository, which you
can view in a web browser at `http://<your-user-id>.github.io/BAMRU-Org`.

See [GitHub Pages](http://pages.github.com) to learn more.


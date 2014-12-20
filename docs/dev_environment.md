# BAMRU.org Development Environment

This information is relevant to Designers and Coders, as outlined in the
[README](../README.md) file.

## Repo Setup

Before starting, you must have update rights on the repo.  See AndyL for
this.

Clone the repo and make sure there is a gh-pages branch which holds the HTML output.

    git clone git@github.com:andyl/BAMRU-Org.git # clone the repo
    git branches -a                              # show all branches - look for `gh-pages`
    git checkout -b gh-pages origin/gh-pages     # make a local copy of `gh-pages` 

## Support Software

This site depends on Ruby 2.1.5.  Use a Ruby version manager like `RVM`,
`rbenv` or `chruby` to setup Ruby.  Once ruby is configured, install the
bundled Ruby Gems (including `Middleman`)

    ruby-install ruby 2.1.5
    cd <dir>/BAMRU-Org
    gem install bundler
    bundle

## Building the Site

Project input is read from the `src` directory.

To run the generator:

    cd <dir>/BAMRU-Org
    bundle exec middleman build

Project output is written to the `out` directory.

## Deploying the Site

The project is hosted on github pages.  Output HTML is stored on the
`gh-pages` branch.

The manual deploy process looks like this:

    cd <dir>/BAMRU-Org
    rm -rf /tmp/output
    cp -r output /tmp
    git checkout gh-pages
    rm -rf .
    cp -r /tmp/output/* .
    git add .
    git commit -am'update website'
    git push
    git checkout master

See [GitHub Pages](http://pages.github.com) to learn more.

## Rake Tasks

The build and deploy tasks have been automated using a Ruby tool called
[Rake](http://en.wikipedia.org/wiki/Rake_%28software%29).

To view all of the Rake options, type `rake -T`.

Most important Rake tasks include:

    rake site:build      # run the build command
    rake site:deploy     # run the deploy script 

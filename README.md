# BAMRU.org website

## Repo Setup

You must have update rights on the repo.

First step is to make sure there is a gh-pages branch which holds the HTML output.

    git clone git@github.com:andyl/mvcondo.git    # clone the repo
    git branches -a                               # show all branches
    git checkout -b gh-pages origin/gh-pages      # make a local copy of the 'gh-pages' branch

## Support Software

This site depends on Ruby 2.1.2 and the `middleman` gem.

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

  

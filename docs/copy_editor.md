# How to be a Copy Editor

View the [README](../README.md)

## Overview

1. Setup [development environment](./dev_environment.md)
2. Edit markdown files under the `/src` directory.
3. Test your edits locally. (see below)
4. Rebuild and deploy the site. (see below)

## Testing Locally

1. Run a local development server using `rake dev:serve`
2. Point your browser at `localhost:4567`

## Updating the HTML Calendar

Follow these steps:

    > rake data:bnet:download  # Download event data from BAMRU.net
    > rake data:bnet:refine    # Refine BNET csv data to YAML
    > rake site:build          # Rebuild the calendar pages

Then you can test locally, and rebuild the site.

## Issue Pull Request

After you committed your changes, push them to your GitHub repo, then create an
upstream Pull Request.

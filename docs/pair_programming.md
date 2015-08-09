# Pair Programming

[Index](./index.md)

## Overview

Sometimes it is handy to have remote sessions whereby two people can view a
shared text editor and command-line console.

## Support Software

To make this work, you will need to use:

- VIM   - a common text editor
- TMUX  - terminal multiplexer software
- WEMUX - multi-user TMUX extensions

## Port Forwarding

Use Port Forwarding to expose your development machine to your partner outside
your firewall.

The ip address of the public server is 45.79.82.37. Ask Andy for a user
account.

The script bin/portfwd sets up ports. Use port 22 for SSH, port 4567 for
the development web server.

## Working Together

Two developers can share a WEMUX session for pair programming. 

First, the host must run:

    > bin/portfwd 22 2222   # start port-forwarding session
    > wemux                 # start wemux session

Then the partner must run:

    > ssh 45.79.82.37:2222    # connect to dev machine via public server

That's it!

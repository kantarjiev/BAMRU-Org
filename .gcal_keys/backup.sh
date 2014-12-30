#!/usr/bin/env bash

SRC=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TGT=/tmp/gcal_keys

mkdir -p $TGT
cp $SRC/* $TGT
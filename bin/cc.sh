#!/bin/bash

#opts="--nogit --nogit-fallback --norolestats"
opts="--norolestats"

for i in "$@"; do
    if [[ $(basename "$i") =~ ^0000- ]] ; then
        ./scripts/get_maintainer.pl --nom $opts $(dirname $1)/*
    else
        ./scripts/get_maintainer.pl $opts $1
    fi
done | sort -u

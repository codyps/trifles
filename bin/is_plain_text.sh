#!/bin/sh

F="$1"

if file "$F" | grep -q text; then
	exit 0
else
	exit 1
fi

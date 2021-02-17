#!/bin/bash

# exclude vendor/
SOURCES="./oragono.go ./irc"

: ${GOFMT:=gofmt}

if [ "$1" = "--fix" ]; then
	exec $GOFMT -s -w $SOURCES
fi

if [ -n "$($GOFMT -s -l $SOURCES)" ]; then
    echo "Go code is not formatted correctly with \`gofmt -s\`:"
    $GOFMT -s -d $SOURCES
    exit 1
fi

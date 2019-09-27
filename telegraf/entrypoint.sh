#!/bin/bash
set -e
if [ $@ ];then
    if [ "$@" = '-' ]; then
        set -- telegraf "$@"
    fi
fi

exec "$@"

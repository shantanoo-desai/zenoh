#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- /usr/local/bin/zenohd "$@"
fi

exec "$@"

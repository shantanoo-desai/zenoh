#!/bin/sh
set -e
ls -la /usr/bin/

if [ "${1:0:1}" = '-' ]; then
    set -- /usr/bin/zenohd "$@"
fi

exec "$@"

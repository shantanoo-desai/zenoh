#!/bin/ash
set -ex

if [ "${1:0:1}" = '-' ]; then
    ls -la /usr/local/bin/ ; ls -la /;
    set -- /usr/local/bin/zenohd "$@"
fi

exec "$@"

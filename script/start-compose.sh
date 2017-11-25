#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.


POSTGIS_HOST="postgres"
POSTGIS_PORT="5432"
set -e


i=0
while ! nc $POSTGIS_HOST $POSTGIS_PORT >/dev/null 2>&1 < /dev/null; do
    i=$((i+1))
    if [ $i -ge $TRY_LOOP ]; then
        echo "$(date) - ${POSTGIS_HOST}:${POSTGIS_PORT} still not reachable, giving up"
        exit 1
    fi
    echo "$(date) - waiting for ${POSTGIS_HOST}:${POSTGIS_PORT}... $i/$TRY_LOOP"
    sleep 5
done

. /usr/local/bin/start.sh jupyter notebook $*

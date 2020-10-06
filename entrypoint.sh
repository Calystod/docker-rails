#!/bin/sh

cp -r /usr/src/app2/* /usr/src/app
exec "$@"

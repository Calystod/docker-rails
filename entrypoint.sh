#!/bin/sh

cp -r /usr/src/app2/* /usr/src/app
cp -r /usr/local/bundle/* /usr/src/app/vendor
exec "$@"

#!/usr/bin/with-contenv bashio
# Creates initial configuration in case it is non-existing
if ! bashio::fs.directory_exists '/config/victoria-metrics'; then
    cp -R /root/victoria-metrics /config/victoria-metrics \
        || bashio::exit.nok 'Failed to create initial Victoria Metrics configuration'
fi

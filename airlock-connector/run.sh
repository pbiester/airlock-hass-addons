#!/usr/bin/with-contenv bashio
# ==============================================================================
# Airlock Connector — start script
# Maps add-on options to the connector's environment and execs it. The connector
# itself supervises frpc (with backoff) and persists its key/cert under /data.
# ==============================================================================
set -e

if bashio::config.is_empty 'server'; then
    bashio::exit.nok "Option 'server' is required — your control-plane connect host, e.g. connect.apps.example.com"
fi

export AIRLOCK_SERVER="$(bashio::config 'server')"
export AIRLOCK_DATA="/data"
export AIRLOCK_POLL="$(bashio::config 'poll_seconds')"
export AIRLOCK_RENEW_BEFORE_DAYS="$(bashio::config 'renew_before_days')"

if bashio::config.has_value 'enroll_token'; then
    export AIRLOCK_ENROLL_TOKEN="$(bashio::config 'enroll_token')"
fi

if bashio::fs.file_exists '/data/client.crt'; then
    bashio::log.info "Certificate present in /data — connecting to ${AIRLOCK_SERVER}"
else
    bashio::log.info "No certificate yet — enrolling with ${AIRLOCK_SERVER} (one-time token)"
    if ! bashio::config.has_value 'enroll_token'; then
        bashio::log.warning "No 'enroll_token' set and no certificate present — enrollment will fail until you add the token from the Airlock dashboard."
    fi
fi

exec /usr/local/bin/airlock-connector

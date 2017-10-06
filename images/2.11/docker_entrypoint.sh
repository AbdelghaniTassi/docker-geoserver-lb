#!/bin/bash
touch $GEOSERVER_LOG_LOCATION
python /usr/local/catalog_watchdog.py &
sh ${CATALINA_HOME}/bin/catalina.sh run
exec "$@"

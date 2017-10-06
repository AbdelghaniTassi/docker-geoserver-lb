# docker-geoserver-lb

A docker cluster with loadbalanced geoserver's using nginx and postgres/postgis with absolutely no promises! Geoserver is heavily influenced by https://github.com/thinkWhere/GeoServer-Docker and https://github.com/kartoza/docker-geoserver.

By default, docker-compose.yml launches 2 geoserver instances, where one is a writable master and the other a slave. Any interactions with the geoserver web/rest interface uses the master instance. After any change to the catalog configuration is detected, slaves will reload its configuration.

Geoserver user: admin/geoserver  
Postgres user: postgres/postgres

## Running:

```shell
docker-compose up -d
```

Geoserver master available at: http://localhost  
Geoserver slave(s) available on http://localhost/\<workspace\>/(wms|ows|gwc)  
Postgis available at: localhost:15432

In /volumes folder you'll find:
* geo_data - Place or symlink your geodata here (vectors, raster etc)
* gs_data - Geoserver data folder
* gwc_data - Geowebcache cache folder
* pg_data - Postgres/Postgis database
* logs - Geoserver/CatalogWatchdog/Tomcat/Nginx logs

**Note:** In geoserver when adding a new store, navigate to /opt/geoserver/geo_data.

## Building:

If the registry is not enough and you need additional plugins/fonts etc, you can build the image yourself. See images/\<version\>/build.sh.

## Slaves:

Add more slaves by adding them to docker-compose.yml and config/nginx/nginx.conf. 

## Passwords:

Geoserver: Use web interface to change it. When done, change environment variable "GEOSERVER_CATALOG_WATCHDOG_CREDENTIALS" in docker-compose.yml and relaunch slaves.  
Postgres/Postgis: Update environment variable POSTGRES_PASSWORD in docker-compose.yml before launch.

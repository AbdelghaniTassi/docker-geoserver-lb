# docker-geoserver-lb

A docker cluster with loadbalanced geoserver's using nginx and postgis with absolutely no promises!

Geoserver heavily influenced by https://github.com/thinkWhere/GeoServer-Docker and https://github.com/kartoza/docker-geoserver.

Geoserver user: admin/geoserver  
Postgres user: postgres/postgres

# Running

First build image:
```shell
cd images/2.12 && sh build.sh
```

Then add execute permission on entrypoint:
```shell
chmod +x config/geoserver/docker_entrypoint.sh
```

Then:
```shell
docker-compose up -d
```
Then: Wait a minute

Then:
Geoserver master available at: http://localhost  
Postgis available at: localhost:15432

In /volumes folder you'll find:
* geo_data - Place or symlink your geodata here (vectors, raster etc)
* gs_data - Geoserver data folder
* gwc_data - Geowebcache cache folder
* pg_data - Postgis data
* logs - Geoserver/Tomcat/Nginx logs

**Note:** At first run, the empty volumes/gs_data folder will most likely cause race conditions between geoserver instances when creating configurations. Simply restart to solve this. 

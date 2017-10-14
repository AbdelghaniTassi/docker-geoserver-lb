#!/bin/bash

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Create plugins folder if does not exist
if [ ! -d $DIR/resources ]
then
    mkdir $DIR/resources
fi

if [ ! -d $DIR/resources/plugins ]
then
    mkdir $DIR/resources/plugins
fi

if [ ! -d $DIR/resources/fonts ]
then
    mkdir $DIR/resources/fonts
fi

GS_VERSION=2.12.0
GS_COMMUNITY_VERSION=2.12

# Add in selected plugins.  Comment out or modify as required
if [ ! -f $DIR/resources/plugins/geoserver-control-flow-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-control-flow-plugin.zip -O $DIR/resources/plugins/geoserver-control-flow-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-inspire-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-inspire-plugin.zip -O $DIR/resources/plugins/geoserver-inspire-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-monitor-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-monitor-plugin.zip -O $DIR/resources/plugins/geoserver-monitor-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-gdal-plugin.zip ]
then
    wget -c http://netix.dl.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-gdal-plugin.zip -O $DIR/resources/plugins/geoserver-gdal-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-vectortiles-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-vectortiles-plugin.zip -O $DIR/resources/plugins/geoserver-vectortiles-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-libjpeg-turbo-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-libjpeg-turbo-plugin.zip -O $DIR/resources/plugins/geoserver-libjpeg-turbo-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-ogr-wfs-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-ogr-wfs-plugin.zip -O $DIR/resources/plugins/geoserver-ogr-wfs-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-ogr-wps-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-ogr-wps-plugin.zip -O $DIR/resources/plugins/geoserver-ogr-wps-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-wps-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-wps-plugin.zip -O $DIR/resources/plugins/geoserver-wps-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-css-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-css-plugin.zip -O $DIR/resources/plugins/geoserver-css-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-pyramid-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-pyramid-plugin.zip -O $DIR/resources/plugins/geoserver-pyramid-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-importer-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-importer-plugin.zip -O $DIR/resources/plugins/geoserver-importer-plugin.zip
fi

# Community plugins
if [ ! -f $DIR/resources/plugins/geoserver-mbstyle-plugin.zip ]
then
    wget -c http://ares.boundlessgeo.com/geoserver/${GS_COMMUNITY_VERSION}.x/community-latest/geoserver-${GS_COMMUNITY_VERSION}-SNAPSHOT-mbstyle-plugin.zip -O $DIR/resources/plugins/geoserver-mbstyle-plugin.zip
fi
if [ ! -f $DIR/resources/plugins/geoserver-mbtiles-plugin.zip ]
then
    wget -c http://ares.boundlessgeo.com/geoserver/${GS_COMMUNITY_VERSION}.x/community-latest/geoserver-${GS_COMMUNITY_VERSION}-SNAPSHOT-mbstyle-plugin.zip -O $DIR/resources/plugins/geoserver-mbtiles-plugin.zip
fi

docker build --build-arg TOMCAT_EXTRAS=false -t wootapa/geoserver:2.12 $DIR

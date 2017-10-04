#!/bin/bash

# Create plugins folder if does not exist
if [ ! -d ./resources ]
then
    mkdir ./resources
fi

if [ ! -d ./resources/plugins ]
then
    mkdir ./resources/plugins
fi

if [ ! -d ./resources/fonts ]
then
    mkdir ./resources/fonts
fi

GS_VERSION=2.12-beta
GS_COMMUNITY_TAG=master
GS_COMMUNITY_VERSION=2.12-SNAPSHOT

# Add in selected plugins.  Comment out or modify as required
if [ ! -f resources/plugins/geoserver-control-flow-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-control-flow-plugin.zip -O resources/plugins/geoserver-control-flow-plugin.zip
fi
if [ ! -f resources/plugins/geoserver-inspire-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-inspire-plugin.zip -O resources/plugins/geoserver-inspire-plugin.zip
fi
if [ ! -f resources/plugins/geoserver-monitor-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-monitor-plugin.zip -O resources/plugins/geoserver-monitor-plugin.zip
fi
if [ ! -f resources/plugins/geoserver-gdal-plugin.zip ]
then
    wget -c http://netix.dl.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-gdal-plugin.zip -O resources/plugins/geoserver-gdal-plugin.zip
fi
if [ ! -f resources/plugins/geoserver-vectortiles-plugin.zip ]
then
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-vectortiles-plugin.zip -O resources/plugins/geoserver-vectortiles-plugin.zip
fi
#if [ ! -f resources/plugins/geoserver-mbstyle-plugin.zip ]
#then
#    wget -c http://ares.opengeo.org/geoserver/${GS_COMMUNITY_TAG}/community-latest/geoserver-${GS_COMMUNITY_VERSION}-mbstyle-plugin.zip -O resources/plugins/geoserver-mbstyle-plugin.zip
#fi
#if [ ! -f resources/plugins/geoserver-mbtiles-plugin.zip ]
#then
#    wget -c http://ares.opengeo.org/geoserver/${GS_COMMUNITY_TAG}/community-latest/geoserver-${GS_COMMUNITY_VERSION}-mbtiles-plugin.zip -O resources/plugins/geoserver-mbtiles-plugin.zip
#fi

docker build --build-arg TOMCAT_EXTRAS=false -t wootapa/geoserver:2.12 .

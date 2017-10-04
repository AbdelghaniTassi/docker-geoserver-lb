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

GS_VERSION=2.11.2

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

docker build --build-arg TOMCAT_EXTRAS=false -t wootapa/geoserver:2.11 .

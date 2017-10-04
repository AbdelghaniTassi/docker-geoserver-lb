#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM tomcat:8.5
MAINTAINER wootapa<apesv03@gmail.com>
#Credit thinkWhere<info@thinkwhere.com>
#Credit: Tim Sutton<tim@linfiniti.com>
# kartoza/docker-geoserver

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND=noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
#RUN  ln -s /bin/true /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
#RUN echo 'Acquire::http { Proxy "http://172.17.0.3:3142"; };' >> /etc/apt/apt.conf.d/apt-cacher-ng

RUN apt-get -y update
RUN apt-get install -y vim
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN apt-get install -y procps

#-------------Application Specific Stuff ----------------------------------------------------

ENV GS_VERSION 2.12-beta
ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR "${GEOSERVER_HOME}/data_dir"
ENV GEOSERVER_LOGS "${GEOSERVER_HOME}/logs"
RUN mkdir -p $GEOSERVER_DATA_DIR
RUN mkdir -p $GEOSERVER_LOGS

# Install python libs for catalog_watchdog.py
RUN pip install watchdog requests

# Unset Java related ENVs since they may change with Oracle JDK
ENV JAVA_VERSION=
ENV JAVA_DEBIAN_VERSION=

# Set JAVA_HOME to /usr/lib/jvm/default-java and link it to OpenJDK installation
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java
ENV JAVA_HOME /usr/lib/jvm/default-java

ADD resources /tmp/resources

# Add JAI and ImageIO for improved performance.
WORKDIR /tmp
ARG JAI_IMAGEIO=true
RUN if [ "$JAI_IMAGEIO" = true ]; then \
    wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
    gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
    mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    rm /tmp/jai-1_1_3-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai-1_1_3 && \
    rm /tmp/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai_imageio-1_1; \
    fi
	
# Add GDAL native libraries
ARG GDAL_NATIVE=true
ENV GDAL_DATA $CATALINA_HOME/gdal-data
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64/gdal
RUN if [ "$GDAL_NATIVE" = true ]; then \
    wget http://demo.geo-solutions.it/share/github/imageio-ext/releases/1.1.X/1.1.12/native/gdal/gdal-data.zip && \
    wget http://demo.geo-solutions.it/share/github/imageio-ext/releases/1.1.X/1.1.12/native/gdal/linux/gdal192-Ubuntu12-gcc4.6.3-x86_64.tar.gz && \
    unzip gdal-data.zip -d $CATALINA_HOME && \
    mkdir $JAVA_HOME/jre/lib/amd64/gdal && \
    tar -xvf gdal192-Ubuntu12-gcc4.6.3-x86_64.tar.gz -C $LD_LIBRARY_PATH; \
    fi

# Add marlin renderer
ENV MARLIN_DIR $CATALINA_HOME/marlin
ENV MARLIN_VERSION 0.8.1
RUN mkdir -p $MARLIN_DIR && \
    wget https://github.com/bourgesl/marlin-renderer/releases/download/v${MARLIN_VERSION}/marlin-${MARLIN_VERSION}-Unsafe.jar -P $MARLIN_DIR && \
    wget https://github.com/bourgesl/marlin-renderer/releases/download/v${MARLIN_VERSION}/marlin-${MARLIN_VERSION}-Unsafe-sun-java2d.jar -P $MARLIN_DIR;
ENV CATALINA_OPTS "-Xbootclasspath/a:${MARLIN_DIR}/marlin-${MARLIN_VERSION}-Unsafe.jar -Xbootclasspath/p:${MARLIN_DIR}/marlin-${MARLIN_VERSION}-Unsafe-sun-java2d.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine"

WORKDIR $CATALINA_HOME

# Fetch the geoserver war file if it is not available locally
RUN if [ ! -f /tmp/resources/geoserver.zip ]; then \
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/geoserver-${GS_VERSION}-war.zip \
      -O /tmp/resources/geoserver.zip; \
    fi; \
    unzip /tmp/resources/geoserver.zip -d /tmp/geoserver \
    && unzip /tmp/geoserver/geoserver.war -d $CATALINA_HOME/webapps/geoserver \
    && rm -rf $CATALINA_HOME/webapps/geoserver/data \
    && rm -rf /tmp/geoserver

# Install resources/plugins
RUN if ls /tmp/resources/plugins/*.zip > /dev/null 2>&1; then \
      for p in /tmp/resources/plugins/*.zip; do \
        unzip $p -d /tmp/gs_plugin \
        && mv /tmp/gs_plugin/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/ \
        && rm -rf /tmp/gs_plugin; \
      done; \
    fi;

# install Font files in resources/fonts if they exist
RUN if ls /tmp/resources/fonts/*.ttf > /dev/null 2>&1; then \
      cp -rf /tmp/resources/fonts/*.ttf /usr/share/fonts/truetype/; \
	fi;

# Optionally remove Tomcat manager, docs, and examples
ARG TOMCAT_EXTRAS=true
RUN if [ "$TOMCAT_EXTRAS" = false ]; then \
    rm -rf $CATALINA_HOME/webapps/ROOT && \
    rm -rf $CATALINA_HOME/webapps/docs && \
    rm -rf $CATALINA_HOME/webapps/examples && \
    rm -rf $CATALINA_HOME/webapps/host-manager && \
    rm -rf $CATALINA_HOME/webapps/manager; \
  fi;

# Delete resources after installation
RUN rm -rf /tmp/resources
EXPOSE 8080

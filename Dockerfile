# AUTHOR: Maksim Pecherskiy
# DESCRIPTION:
# BUILD: docker build --rm -t mrmaksimize/docker_geostack.
# SOURCE: https://github.com/mrmaksimize/docker_geostack

FROM jupyter/datascience-notebook

# Configure environment - matches base notebook
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

USER root

WORKDIR $HOME

# Never prompts the user for choices on installation/configuration of packages

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# GDAL data env
ENV GDAL_DATA /usr/share/gdal/2.1

# Debian packages and libraries
RUN set -ex \
    && buildDeps=' \
        #python-dev \
        #libkrb5-dev \
        #libsasl2-dev \
        #libssl-dev \
        #libffi-dev \
        #build-essential \
        #libcurl4-gnutls-dev \
        #libnetcdf-dev \
        #libpoppler-dev \
        #libhdf4-alt-dev \
        #libhdf5-serial-dev \
        #libblas-dev \
        #liblapack-dev \
        #libpq-dev \
        libgdal-dev \
        libproj-dev \
        libgeos-dev \
        libspatialite-dev \
        libspatialindex-dev \
        libfreetype6-dev \
        libxml2-dev \
        libxslt-dev \
        gnupg2 \
        libsqlite3-dev \
        zlib1g-dev \
    ' \
    && apt-get clean -yqq \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        apt-utils \
        curl \
        git \
        netcat \
        #locales \
        #cython \
        python-gdal \
        libaio1 \
        unzip \
        less \
        freetds-dev \
        vim \
        wget \
        gdal-bin \
        sqlite3


## NodeJS packages
## Install node as root.
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

## Switch to NB_USER to install node deps
USER $NB_USER

RUN npm install -g mapshaper \
    && npm install -g @turf/turf \
    && npm install -g geobuf \
    && npm install -g @mapbox/mapbox-tile-copy


# Python packages
RUN pip install boto3 \
    && pip install geojson \
    && pip install pymssql \
    && pip install xlrd \
    && pip install beautifulsoup4 \
    && pip install lxml \
    && pip install geomet \
    && pip install geopy \
    && pip install rtree \
    && pip install shapely \
    && pip install fiona \
    && pip install descartes \
    && pip install pyproj \
    && pip install geopandas

#Switch to Root for cleanup
USER root


# Tippecanoe
WORKDIR /tmp
RUN git clone https://github.com/mapbox/tippecanoe.git \
    && cd ./tippecanoe \
    && make \
    && make install
WORKDIR {HOME}


# Cleaning & setup
RUN apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/start-compose.sh /usr/local/bin/
#
#RUN chown -R airflow: ${AIRFLOW_HOME} \
#    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh \
#    && chown -R airflow /usr/lib/python* /usr/local/lib/python* \
#    && chown -R airflow /usr/lib/python2.7/* /usr/local/lib/python2.7/* \
#    && chown -R airflow /usr/local/bin* /usr/local/bin/* \
#    && sed -i "s|flask.ext.cache|flask_cache|g" /usr/local/lib/python2.7/dist-packages/flask_cache/jinja2ext.py
#
#EXPOSE 8080 5555 8793

WORKDIR ${HOME}

#Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

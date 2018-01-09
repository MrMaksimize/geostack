# AUTHOR: Maksim Pecherskiy
# DESCRIPTION:
# BUILD: docker build --rm -t mrmaksimize/geostack.
# SOURCE: https://github.com/mrmaksimize/geostack

FROM jupyter/scipy-notebook

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
        netcat \
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

RUN npm install -g yarn\
    && yarn global add mapshaper \
    && yarn global add @turf/turf \
    && yarn global add geobuf \
    && yarn global add gulp \
    && yarn global add @mapbox/mapbox-tile-copy


# Python packages
RUN conda install --yes \
    'boto3' \
    'geojson' \
    'pymssql' \
    'xlrd' \
    'beautifulsoup4' \
    'lxml' \
    'geopy' \
    'rtree' \
    'shapely' \
    'fiona' \
    'descartes' \
    'pyproj' \
    'geopandas'

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

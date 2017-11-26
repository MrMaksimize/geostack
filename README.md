# Docker Geostack

## What?
An un-opinionted combination of various available and useful geospatial data tools and helper methods.

Based on [Jupyter DockerStacks SciPy Notebook](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook)
With a lot of input and knowledge from our beloved [Arnaud Vedy](https://github.com/arnaudvedy) and his
[datascience-notbook](https://github.com/arnaudvedy/datascience-notebook)

## How do I use this?
Copy `env.example` to `.env`
Run `docker-compose up` or `docker-compose up -d` if you want to run detached.

#### Jupyter Notebook URL:
http://localhost:8888

#### PostGIS Info
The PostGIS port is exposed at 5432.  Make sure you have copied env.example to .env so the password gets set.
You can connect from a local client or QGIS, but there's an easy interface available at
`http://localhost:8082`


#### Mongo Info
The mongo port is exposed at 27017, so you should be able to connect from a local client.
However, there's an easy admin interface also available at `http://localhost:8081`

Username is `admin`
Pass is `pass`


#### Data Persistence
Data from Mongo and Postgis are persisted in the `db` directory.
Your jupyter notebook are saved and synced to the `work` directory.


## When should I NOT use this?
In production.  No security precautions have been taken outside of making this a local dev environment.

## Why?
Because installing all this and orchestrating it together is hard.  Docker-Compose makes it easy.

## What's in here?

### Databases
* Mongo (you can [do some awesome geo stuff in mongo](https://docs.mongodb.com/manual/geospatial-queries/))
* PostGIS (the [elephant](http://postgis.net/) of the Geo database world.)

### DB Admin Tools
* Adminer for PostGIS.
* NodeExpress for Mongo.

### Geospatial Tools
#### Node
* [Mapshaper](https://github.com/mbloch/mapshaper)
	* Transformation of geo data
* [GitHub - mapbox/mapbox-tile-copy: From geodata files to tiles on S3](https://github.com/mapbox/mapbox-tile-copy)
* [GitHub - mapbox/geobuf: A compact binary encoding for geographic data.](https://github.com/mapbox/geobuf)
* [Turf.js | Advanced Geospatial Analysis](http://turfjs.org/)

#### Python
* [GeoPandas 0.3.0 — GeoPandas 0.3.0 documentation](http://geopandas.org/)
* [Shapely — Shapely 1.2 and 1.3 documentation](http://toblerity.org/shapely/project.html)
* [Fiona — Fiona 1.7.0.post2 documentation](http://toblerity.org/fiona/README.html)
* [OSGEO / Gdal Interface]
* Geojson
* Geobuf

#### Other
* [GDAL: GDAL - Geospatial Data Abstraction Library](http://www.gdal.org/)
* [GDAL: ogr2ogr](http://www.gdal.org/ogr2ogr.html)
* [Tippecanoe][GitHub - mapbox/tippecanoe: Build vector tilesets from large collections of GeoJSON features.](https://github.com/mapbox/tippecanoe)


### Stuff that's not here but also useful
#### Docker
* [GitHub - Geovation/tiler: A no nonsense Vector Tile pipeline](https://github.com/Geovation/tiler)


### What's next
* Tegola
* Simple vector tile previews


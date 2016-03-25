#!/bin/bash

OSUSER="stefan"

DBADMIN="stefan"
DBADMINPWD="ziegler12"
DBUSR="mspublic"
DBPWD="mspublic"
DBNAME="xanadu2"


# PDAL (w/ all its dependencies)
# laszip
cd ~
apt-get install --yes autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-all-dev libboost-filesystem-dev libboost-timer-dev libcgal-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev postgresql-server-dev-9.3 xsltproc git build-essential wget
wget https://github.com/LASzip/LASzip/releases/download/v2.2.0/laszip-src-2.2.0.tar.gz
tar xvfz laszip-src-2.2.0.tar.gz -C ~/sources/
cd ~/sources/laszip-src-2.2.0/
./configure
make 
make install
cd ~
mkdir /usr/local/include/laszip
cp /usr/local/include/las*.hpp /usr/local/include/laszip/

# liblas
cd ~
wget http://download.osgeo.org/liblas/libLAS-1.8.0.tar.bz2
tar xvfj libLAS-1.8.0.tar.bz2 -C ~/sources/
mkdir ~/sources/libLAS-1.8.0/build
cd ~/sources/libLAS-1.8.0/build
cmake .. -DWITH_GDAL=ON -DWITH_GEOTIFF=ON -DWITH_LASZIP=ON -DWITH_UTILITIES=ON
make -j2
make install
cd ~

# points2grid 
git clone https://github.com/CRREL/points2grid.git ~/sources/points2grid
mkdir ~/sources/points2grid/build
cd ~/sources/points2grid/build
cmake .. -DWITH_GDAL=ON 
make
make install
cd ~

# hexer
git clone https://github.com/hobu/hexer.git ~/sources/hexer
mkdir ~/sources/hexer/build
cd ~/sources/hexer/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
cd ~


add-apt-repository --yes ppa:v-launchpad-jochen-sprickerhof-de/pcl
apt-get --yes update
apt-get --yes install libpcl-all

# pdal
git clone https://github.com/PDAL/PDAL.git ~/sources/pdal
mkdir ~/sources/pdal/build
cd ~/sources/pdal/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_PLUGIN_PCL=ON -DBUILD_PLUGIN_HEXBIN=ON -DBUILD_PLUGIN_P2G=ON -DBUILD_PLUGIN_PGPOINTCLOUD=ON -DBUILD_PLUGIN_PYTHON=ON -DBUILD_PLUGIN_SQLITE=ON -DWITH_APPS=ON -DWITH_GEOTIFF=ON -DWITH_LASZIP=ON -DWITH_COMPLETION=ON
make -j2
make install
cd ~

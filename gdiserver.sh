#!/bin/bash


# Update system
#apt-get update
#apt-get --yes dist-upgrade

# Install Oracle Java (silent option for accepting license)
#add-apt-repository --yes ppa:webupd8team/java
#apt-get update
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#apt-get --yes install oracle-java8-installer

# Add ubuntugis-unstable apt repository and keys
# Port 80 b/c of firewall.
#add-apt-repository --yes ppa:ubuntugis/ubuntugis-unstable
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80/ --recv-key 314DF160
#apt-get update


# Install and configure PostGIS
#apt-get --yes install postgis postgresql-9.3-postgis-2.1
#apt-get --yes install pgadmin3

# Compile and install QGIS Master
#apt-get --yes build-dep qgis
#apt-get --yes install libqscintilla2-dev cmake-curses-gui cmake-qt-gui gdal-bin python-gdal python-qscintilla2 git

# Download NTv2 grids and copy to /usr/share/proj/
#apt-get --yes install proj-bin zip curl
#curl -O http://www.swisstopo.admin.ch/internet/swisstopo/de/home/products/software/software.parsys.7090.downloadList.55545.DownloadFile.tmp/chenyx06ntv2.zip
#unzip -d /usr/share/proj/ chenyx06ntv2.zip CHENYX06a.gsb

#apt-get --yes install gdal-bin
#gdalversion=`gdalinfo --version | awk -F ' '  '{ print $2 }' | awk -F . '{ print $1 "." $2 }'`
#echo "4149,CH1903,6149,CH1903,6149,9122,7004,8901,1,0,6422,1766,1,9603,674.374,15.056,405.346,,,," >> /usr/share/gdal/$gdalversion/gcs.override.csv

#mkdir ~/sources
#git clone https://github.com/qgis/QGIS.git ~/sources/qgis_master
#mkdir ~/sources/qgis_master/build
#cd ~/sources/qgis_master/build
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/qgis_master -DCMAKE_INSTALL_RPATH=/usr/local/qgis_master/lib -DENABLE_TESTS=OFF -DWITH_SERVER=ON
#make -j2
#make install
#cd ~
#/usr/local/qgis_master/lib/qgis/crssync

# Install some additional stuff
apt-get --yes install vim
apt-get --yes install subversion
apt-get --yes install geany
apt-get --yes install qt4-designer qt4-qtconfig python-qt4-sql libqt4-sql-psql qt4-dev-tools
apt-get --yes install python-psycopg2

# Fonts...

# JAI... (zu Java verschieben)


# PDAL (w/ all dependencies)
apt-get install --yes autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-all-dev libboost-filesystem-dev libboost-timer-dev libcgal-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev postgresql-server-dev-9.3 xsltproc git build-essential wget
wget https://github.com/LASzip/LASzip/releases/download/v2.2.0/laszip-src-2.2.0.tar.gz
tar xvfz laszip-src-2.2.0.tar.gz -C ~/sources/
cd ~/sources/laszip-src-2.2.0/
./configure
make 
make install


#cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/laszip -DCMAKE_INSTALL_RPATH=/usr/local/laszip/lib





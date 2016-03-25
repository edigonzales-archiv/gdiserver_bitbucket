#!/bin/bash

OSUSER="stefan"

DBADMIN="stefan"
DBADMINPWD="ziegler12"
DBUSR="mspublic"
DBPWD="mspublic"
DBNAME="xanadu2"

# Create a source and apps directory.
mkdir ~/sources
mkdir ~/Apps
chown -R $OSUSER:$OSUSER Apps/

# Install and configure PostGIS
apt-get --yes install postgis postgresql-9.3-postgis-2.1
apt-get --yes install pgadmin3

# Compile and install QGIS Master
apt-get --yes build-dep qgis
apt-get --yes install libqca2-dev libqca2-plugin-ossl libqscintilla2-dev cmake-curses-gui cmake-qt-gui gdal-bin python-gdal python-qscintilla2 git


# Download NTv2 grids and copy to /usr/share/proj/
cd ~
apt-get --yes install proj-bin zip curl
#http://www.swisstopo.admin.ch/internet/swisstopo/en/home/products/software/products/chenyx06.parsys.00011.downloadList.70576.DownloadFile.tmp/chenyx06ntv2.zip
#wget https://www.dropbox.com/s/4uwil0xfcki8m8h/chenyx06ntv2.zip?dl=0 -O chenyx06ntv2.zip
wget https://www.dropbox.com/s/mqyg3d7grxpa531/chenyx06ntv2.zip?dl=0 -O chenyx06ntv2.zip
unzip -d /usr/share/proj/ chenyx06ntv2.zip CHENYX06a.gsb
chmod 644 /usr/share/proj/CHENYX06a.gsb

apt-get --yes install gdal-bin
gdalversion=`gdalinfo --version | awk -F ' '  '{ print $2 }' | awk -F . '{ print $1 "." $2 }'`
echo "4149,CH1903,6149,CH1903,6149,9122,7004,8901,1,0,6422,1766,1,9603,674.374,15.056,405.346,,,," >> /usr/share/gdal/$gdalversion/gcs.override.csv

# GDAL/OGR develop
cd ~
mkdir /usr/local/gdal_master/
git clone https://github.com/OSGeo/gdal.git ~/sources/gdal_master
cd ~/sources/gdal_master/gdal
./configure --prefix=/usr/local/gdal_master/ --with-spatialite=yes --with-sqlite3=yes --with-python=yes
make install

sudo sh -c "echo '/usr/local/gdal_master/lib' >> /etc/ld.so.conf"
sudo ldconfig

echo "4149,CH1903,6149,CH1903,6149,9122,7004,8901,1,0,6422,1766,1,9603,674.374,15.056,405.346,,,," >> /usr/local/gdal_master/share/gdal/gcs.override.csv 

# QGIS
git clone https://github.com/qgis/QGIS.git ~/sources/qgis_master
mkdir ~/sources/qgis_master/build
cd ~/sources/qgis_master/build
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/qgis_master -DCMAKE_INSTALL_RPATH=/usr/local/qgis_master/lib -DENABLE_TESTS=OFF -DWITH_SERVER=OFF -DWITH_CUSTOM_WIDGETS=ON -DWITH_PYSPATIALITE=ON -DWITH_QSPATIALITE=ON
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/qgis_master -DCMAKE_INSTALL_RPATH=/usr/local/qgis_master/lib -DENABLE_TESTS=OFF -DWITH_SERVER=OFF -DWITH_CUSTOM_WIDGETS=ON -DWITH_PYSPATIALITE=ON -DWITH_QSPATIALITE=ON -DGDAL_CONFIG=/usr/local/gdal_master/bin/gdal-config -DGDAL_INCLUDE_DIR=/usr/local/gdal_master/include -DGDAL_LIBRARY=/usr/local/gdal_master/lib/libgdal.so -DWITH_INTERNAL_QWTPOLAR=ON
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/qgis_master -DCMAKE_INSTALL_RPATH=/usr/local/qgis_master/lib -DWITH_SERVER=OFF -DWITH_CUSTOM_WIDGETS=ON -DWITH_PYSPATIALITE=ON -DWITH_QSPATIALITE=ON -DGDAL_CONFIG=/usr/local/gdal_master/bin/gdal-config -DGDAL_INCLUDE_DIR=/usr/local/gdal_master/include -DGDAL_LIBRARY=/usr/local/gdal_master/lib/libgdal.so -DWITH_INTERNAL_QWTPOLAR=ON -DBUILD_TESTING=ON -DENABLE_MODELTEST=ON -DENABLE_TESTS=ON
make -j3
make install
cd ~
/usr/local/qgis_master/lib/qgis/crssync


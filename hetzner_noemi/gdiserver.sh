#!/bin/bash

OSUSER="stefan"

DBADMIN="stefan"
DBADMINPWD="ziegler12"
DBUSR="mspublic"
DBPWD="mspublic"
DBNAME="xanadu2"


# Update system
apt-get update
apt-get --yes dist-upgrade
apt-get --yes install language-pack-de

# xfce
add-apt-repository --yes ppa:xubuntu-dev/xfce-4.12
apt-get --yes install xubuntu-desktop

# Add ubuntugis-unstable apt repository and keys
# Port 80 b/c of firewall.
add-apt-repository --yes ppa:ubuntugis/ubuntugis-unstable
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80/ --recv-key 314DF160
apt-get update

# Create a source and apps directory.
mkdir ~/sources
mkdir ~/Apps
chown -R $OSUSER:$OSUSER Apps/

# Install and configure PostGIS
apt-get --yes install postgis postgresql-9.3-postgis-2.1
apt-get --yes install pgadmin3

# Compile and install QGIS Master
apt-get --yes build-dep qgis
apt-get --yes install libqscintilla2-dev cmake-curses-gui cmake-qt-gui gdal-bin python-gdal python-qscintilla2 git

# Download NTv2 grids and copy to /usr/share/proj/
cd ~
apt-get --yes install proj-bin zip curl
wget http://www.swisstopo.admin.ch/internet/swisstopo/de/home/products/software/software.parsys.7090.downloadList.55545.DownloadFile.tmp/chenyx06ntv2.zip -O chenyx06ntv2.zip
unzip -d /usr/share/proj/ chenyx06ntv2.zip CHENYX06a.gsb
chmod 644 /usr/share/proj/CHENYX06a.gsb

apt-get --yes install gdal-bin
gdalversion=`gdalinfo --version | awk -F ' '  '{ print $2 }' | awk -F . '{ print $1 "." $2 }'`
echo "4149,CH1903,6149,CH1903,6149,9122,7004,8901,1,0,6422,1766,1,9603,674.374,15.056,405.346,,,," >> /usr/share/gdal/$gdalversion/gcs.override.csv

git clone https://github.com/qgis/QGIS.git ~/sources/qgis_master
mkdir ~/sources/qgis_master/build
cd ~/sources/qgis_master/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/qgis_master -DCMAKE_INSTALL_RPATH=/usr/local/qgis_master/lib -DENABLE_TESTS=OFF -DWITH_SERVER=OFF -DWITH_CUSTOM_WIDGETS=ON -DWITH_PYSPATIALITE=ON -DWITH_QSPATIALITE=ON
make -j2
make install
cd ~
/usr/local/qgis_master/lib/qgis/crssync

# Install some additional stuff
apt-get --yes install vim
apt-get --yes install subversion
apt-get --yes install geany
apt-get --yes install qt4-designer qt4-qtconfig python-qt4-sql libqt4-sql-psql qt4-dev-tools
apt-get --yes install python-psycopg2
apt-get --yes install x2goclient
apt-get --yes install sshfs

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

# pdal
git clone https://github.com/PDAL/PDAL.git ~/sources/pdal
mkdir ~/sources/pdal/build
cd ~/sources/pdal/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_PLUGIN_HEXBIN=ON -DBUILD_PLUGIN_P2G=ON -DBUILD_PLUGIN_PGPOINTCLOUD=ON -DBUILD_PLUGIN_PYTHON=ON -DBUILD_PLUGIN_SQLITE=ON -DWITH_APPS=ON -DWITH_GEOTIFF=ON -DWITH_LASZIP=ON
make -j2
make install
cd ~

# Install Oracle Java (silent option for accepting license)
add-apt-repository --yes ppa:webupd8team/java
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get --yes install oracle-java8-installer

# Install native JAI
# Silent overwrite will not work.
cd ~
wget https://www.dropbox.com/s/7mwcvtreipufy0u/jai-1_1_3-lib-linux-amd64-jdk.bin?dl=0 -O jai-1_1_3-lib-linux-amd64-jdk.bin
cp jai-1_1_3-lib-linux-amd64-jdk.bin /usr/lib/jvm/java-8-oracle/
cd /usr/lib/jvm/java-8-oracle/
sh ./jai-1_1_3-lib-linux-amd64-jdk.bin >/dev/null < <(echo y) >/dev/null < <(echo y)
cd ~

#cd ~
wget https://www.dropbox.com/s/arpsxaumi0f9hzp/jai_imageio-1_1-lib-linux-amd64-jdk.bin?dl=0 -O jai_imageio-1_1-lib-linux-amd64-jdk.bin
sed s/+215/-n+215/ jai_imageio-1_1-lib-linux-amd64-jdk.bin > jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin
cp jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin /usr/lib/jvm/java-8-oracle/
cd /usr/lib/jvm/java-8-oracle/
_POSIX2_VERSION=199209 sh ./jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin >/dev/null < <(echo y) >/dev/null < <(echo y)
cd ~

# Maven (add also Geoscript bin to path)
cd ~
wget http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz -O apache-maven-3.3.3-bin.tar.gz
tar xvfz apache-maven-3.3.3-bin.tar.gz -C ~/Apps/
chown -R $OSUSER:$OSUSER ~/Apps/apache-maven-3.3.3/
chmod +rx -R ~/Apps/apache-maven-3.3.3/
echo "export PATH=$PATH:/home/$OSUSER/Apps/apache-maven-3.3.3/bin:/home/$OSUSER/Apps/geoscript-groovy/bin" >> /home/$OSUSER/.bashrc
cd ~

# GVM
cd ~
curl -s get.gvmtool.net | bash
source "/home/$OSUSER/.gvm/bin/gvm-init.sh"
chown -R $OSUSER:$OSUSER ~/.gvm
echo "gvm_auto_answer=true" >> ~/.gvm/etc/config
cd ~

# Groovy
cd ~
gvm install groovy

# Gradle
cd ~
gvm install gradle

# Geoscript
git clone git://github.com/jericks/geoscript-groovy.git ~/sources/geoscript-groovy
cd ~/sources/geoscript-groovy/
PATH=$PATH:/home/$OSUSER/Apps/apache-maven-3.3.3/bin mvn clean install -DskipTests
mkdir ~/Apps/geoscript-groovy/
cp -r ~/sources/geoscript-groovy/target/geoscript-groovy-1.6-SNAPSHOT-app/geoscript-groovy-1.6-SNAPSHOT/* ~/Apps/geoscript-groovy/
chown $OSUSER:$OSUSER -R ~/Apps/geoscript-groovy/
chmod +rx -R ~/Apps/geoscript-groovy/
cd ~

# Create some database roles, create a database and install postgis extension
sudo -u postgres psql -d postgres -c "CREATE ROLE $DBADMIN CREATEDB LOGIN PASSWORD '$DBADMINPWD';"
sudo -u postgres psql -d postgres -c "CREATE ROLE $DBUSR LOGIN PASSWORD '$DBPWD';"
sudo -u postgres dropdb $DBNAME
sudo -u postgres createdb --owner $DBADMIN $DBNAME
sudo -u postgres psql -d $DBNAME -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON SCHEMA public TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "ALTER TABLE geometry_columns OWNER TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON geometry_columns TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON spatial_ref_sys TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON geography_columns TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON raster_columns TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT ALL ON raster_overviews TO $DBADMIN;"
sudo -u postgres psql -d $DBNAME -c "GRANT SELECT ON geometry_columns TO $DBUSR;"
sudo -u postgres psql -d $DBNAME -c "GRANT SELECT ON spatial_ref_sys TO $DBUSR;"
sudo -u postgres psql -d $DBNAME -c "GRANT SELECT ON geography_columns TO $DBUSR;"
sudo -u postgres psql -d $DBNAME -c "GRANT SELECT ON raster_columns TO $DBUSR;"

# ili2pg
cd ~
wget http://www.eisenhutinformatik.ch/tmp/ili2pg-2.1.6.zip -O ili2pg-2.1.6.zip
unzip -d ~/Apps/ ili2pg-2.1.6.zip
chown $OSUSER:$OSUSER -R ~/Apps/ili2pg-2.1.6/
cd ~

#cd ~
wget http://www.catais.org/geodaten/ch/so/agi/av/dm01avch24d/itf/lv03/ch_252400.itf -O ch_252400.itf
java -jar ~/Apps/ili2pg-2.1.6/ili2pg.jar --import --dbhost localhost --dbport 5432 --dbdatabase $DBNAME --dbschema ch_252400 --dbusr $DBADMIN --dbpwd $DBADMINPWD --modeldir http://models.geo.admin.ch --models DM01AVCH24D --createEnumTxtCol --nameByTopic --sqlEnableNull --createGeomIdx ~/ch_252400.itf
cd ~

# Fonts...
cd ~
wget https://www.dropbox.com/s/e4ont2k6onxb018/Cadastra.zip?dl=0 -O Cadastra.zip
unzip -d /usr/share/fonts/truetype/ Cadastra.zip
wget https://www.dropbox.com/s/m24rz3cmwvfsqg1/Frutiger.zip?dl=0 -O Frutiger.zip
unzip -d /usr/share/fonts/truetype/ Frutiger.zip
fc-cache -f -v
cd ~

# x2go server
apt-get --yes install software-properties-common
add-apt-repository --yes ppa:x2go/stable
apt-get update
apt-get --yes install x2goserver x2goserver-xsession

# ftp server
# change some config stuff programmatically!?
# https://wiki.ubuntuusers.de/vsftpd
# only adjust one: write_enable=YES
apt-get --yes install vsftpd 

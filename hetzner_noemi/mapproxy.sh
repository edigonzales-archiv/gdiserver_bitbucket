sudo apt-get --yes install python-imaging python-yaml libproj0
sudo apt-get --yes install libgeos-dev python-lxml libgdal-dev python-shapely
sudo apt-get --yes install build-essential python-dev libjpeg-dev zlib1g-dev libfreetype6-dev
  
sudo apt-get --yes install python-pip
sudo pip install virtualenv virtualenvwrapper

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi




cd /home/stefan/Apps/

virtualenv --system-site-packages mapproxy

cd mapproxy
source bin/activate

pip install Pillow
pip install MapProxy

mapproxy-util create -t base-config mymapproxy

cd mymapproxy
mapproxy-util serve-develop -b localhost:8081  mapproxy.yaml

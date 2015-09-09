#!/bin/bash

apt-get --yes install language-pack-de
locale-gen de_CH.utf8

adduser --gecos "" stefan
adduser stefan sudo

adduser --gecos "" barpastu

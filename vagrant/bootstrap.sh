#!/usr/bin/env bash

################################################################################
#                                                                              #
# Script for provisioning development machine                                  #
#                                                                              #
################################################################################

# Update all system and install yum
sudo apt-get update 2>&1 > /dev/null

# Install required software
# -------------------------
echo "Install software"
echo "================"

# Install JAVA
echo " - Installing Java"
sudo apt-get install openjdk-7-jre -y 2>&1 > /dev/null

# Install Elastic Search
echo " - Installing Elasticsearch 2.3.1"
cd /tmp
wget --quiet https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.1/elasticsearch-2.3.1.deb 2>&1 > /dev/null
sudo dpkg -i elasticsearch-2.3.1.deb 2>&1 > /dev/null
sudo rm elasticsearch-2.3.1.deb
sudo cp /vagrant/vagrant/files/elasticsearch.yml /etc/elasticsearch/ && \
  echo " - Copied elasticsearch configuration"
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head 2>&1 > /dev/null && \
  echo " - ES head plugin installed: http://een:9200/_plugin/head/"
sudo /etc/init.d/elasticsearch start 2>&1 > /dev/null

# /etc/hosts for VirtualHosts
cp /vagrant/vagrant/files/lamp.hosts /etc/hosts && \
  echo " - Copied contents for hosts file"

# PHP.ini
#cp /vagrant/vagrant/files/php.ini /etc/php5/cli/php.ini && \
#  echo "     Copied php.ini file"

# VirtualHost apache files
cp "/vagrant/vagrant/files/een.conf" /etc/apache2/sites-available/ && \
  echo " - Copied een apache config"

# Create cache dir for app
mkdir -p /var/lib/een/cache

# Disable default vhost and enable een
sudo a2dissite 000-default 2>&1 > /dev/null 
sudo a2dissite default-ssl 2>&1 > /dev/null 
sudo a2ensite een 2>&1 > /dev/null

# Restart Apache
service apache2 restart 2>&1 > /dev/null && \
  echo " - Configured apache"

# Copy bashrc
cp /vagrant/vagrant/files/bashrc /home/vagrant/.bashrc && chown vagrant:vagrant /home/vagrant/.bashrc && \
  echo " - Copied .bashrc"

# Update composer version
sudo composer self-update 2>&1 > /dev/null && \
  echo " - Updated composer"

# Nodejs, npm and grunt and all required binaries to use grunt and sass
sudo apt-get install nodejs -y
sudo apt-get install npm -y

sudo npm install -g grunt-cli
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get install ruby-sass -y
echo "Bootstrap complete!"

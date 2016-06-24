#!/usr/bin/env bash

################################################################################
#                                                                              #
# Script for provisioning development machine                                  #
#                                                                              #
################################################################################

# Update all system and install yum
sudo apt-get -qq update > /dev/null 2>&1

# Install required software
# -------------------------
echo "Install software"
echo "================"

# Install JAVA
sudo apt-get -qq install openjdk-7-jre -y > /dev/null 2>&1 && \
  echo " - Installed java"

# Install Elastic Search
cd /tmp
wget --quiet https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.1/elasticsearch-2.3.1.deb > /dev/null 2>&1
sudo dpkg -i elasticsearch-2.3.1.deb > /dev/null 2>&1 && \
  echo " - Installed elasticsearch"
sudo rm elasticsearch-2.3.1.deb
sudo cp /vagrant/vagrant/files/elasticsearch.yml /etc/elasticsearch/ && \
  echo " - Copied elasticsearch configuration"
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head > /dev/null 2>&1 && \
  echo " - ES head plugin installed: http://een:9200/_plugin/head/"
# Add it as a service
sudo update-rc.d elasticsearch defaults 95 10 > /dev/null 2>&1
sudo /etc/init.d/elasticsearch start > /dev/null 2>&1

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
sudo a2dissite 000-default > /dev/null 2>&1 
sudo a2dissite default-ssl > /dev/null 2>&1 
sudo a2ensite een > /dev/null 2>&1

# Restart Apache
service apache2 restart > /dev/null 2>&1 && \
  echo " - Configured apache"

# Copy bashrc
cp /vagrant/vagrant/files/bashrc /home/vagrant/.bashrc && chown vagrant:vagrant /home/vagrant/.bashrc && \
  echo " - Copied .bashrc"

# Update composer version
sudo composer self-update -q > /dev/null 2>&1 && \
  echo " - Updated composer"

# Nodejs, npm and grunt and all required binaries to use grunt and sass
sudo apt-get -qq install nodejs -y > /dev/null 2>&1 && \
  echo " - Installed node"
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get -qq install npm -y > /dev/null 2>&1 && \
  echo " - Installed npm"
sudo npm install -g --silent grunt-cli > /dev/null 2>&1 && \
  echo " - Installed grunt-cli"
sudo apt-get -qq install ruby-sass -y > /dev/null 2>&1 && \
  echo " - Installed sass"
echo "Bootstrap complete!"

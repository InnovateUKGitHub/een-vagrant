#!/usr/bin/env bash

################################################################################
#                                                                              #
# Script for provisioning development machine                                  #
#                                                                              #
################################################################################

# Update all system
sudo apt-get -qq update > /dev/null 2>&1

# Install required software
# -------------------------
echo "Installing software"
echo "==================="

# Install Apache
sudo apt-get -y install apache2 > /dev/null 2>&1 && \
  echo "1 - Apache 2.4 Installed"

# Install PHP 5.6
sudo add-apt-repository ppa:ondrej/php > /dev/null 2>&1
sudo apt-get -y update > /dev/null 2>&1
sudo apt-get -y install php5.6 php5.6-mcrypt php5.6-mbstring php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl > /dev/null 2>&1 && \
  echo "2 - PHP 5.6 Installed"

# Install Mysql 5.6 / Default password for root: password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

sudo apt-get -y -q install mysql-server-5.6 > /dev/null 2>&1 && \
  echo "3 - Mysql 5.6 Installed"

# Install JAVA
sudo apt-get -qq install openjdk-7-jre -y > /dev/null 2>&1 && \
  echo "4 - Java 7 Installed"

# Install Elastic Search
cd /tmp
wget --quiet https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.1/elasticsearch-2.3.1.deb > /dev/null 2>&1
sudo dpkg -i elasticsearch-2.3.1.deb > /dev/null 2>&1 && \
sudo rm elasticsearch-2.3.1.deb && \
  echo "5 - Elasticsearch 2.3 Installed"

sudo cp /vagrant/vagrant/files/elasticsearch.yml /etc/elasticsearch/ && \
  echo "6 - Elasticsearch Configuration Copied "
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head > /dev/null 2>&1 && \
  echo "7 - ES head plugin installed: http://een:9200/_plugin/head/"
# Add it as a service
sudo update-rc.d elasticsearch defaults 95 10 > /dev/null 2>&1
sudo /etc/init.d/elasticsearch start > /dev/null 2>&1

# /etc/hosts for VirtualHosts
cp /vagrant/vagrant/files/lamp.hosts /etc/hosts && \
  echo "8 - Hosts File Copied"

# PHP.ini
cp /vagrant/vagrant/files/php.ini /etc/php/5.6/cli/php.ini && \
 echo " - php.ini Copied"

# my.cnf
cp /vagrant/vagrant/files/my.cnf /etc/mysql/my.cnf && \
  echo "9 - my.cnf Copied"

# VirtualHost apache files
cp /vagrant/vagrant/files/een.conf /etc/apache2/sites-available/ && \
cp /vagrant/vagrant/files/een-api.conf /etc/apache2/sites-available/ && \
  echo "10- Apache Configs Copied"

# Create cache dir for app
mkdir -p /var/lib/een/cache
mkdir -p /var/lib/een-api/cache

# Disable default vhost and enable een
sudo a2dissite 000-default > /dev/null 2>&1 
sudo a2dissite default-ssl > /dev/null 2>&1 
sudo a2ensite een > /dev/null 2>&1
sudo a2ensite een-api > /dev/null 2>&1

# Restart Apache
service apache2 restart > /dev/null 2>&1 && \
  echo "11- Apache Configured"

# Copy bashrc
cp /vagrant/vagrant/files/bashrc /home/vagrant/.bashrc && chown vagrant:vagrant /home/vagrant/.bashrc && \
  echo "12- .bashrc Copied"

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" > /dev/null 2>&1 && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  > /dev/null 2>&1 && \
php composer-setup.php > /dev/null 2>&1 && \
php -r "unlink('composer-setup.php');" > /dev/null 2>&1 && \
sudo mv composer.phar /usr/bin/composer && \
  echo "13- Composer Installed"

# Nodejs, npm and grunt and all required binaries to use grunt and sass
sudo apt-get -qq install nodejs -y > /dev/null 2>&1 && \
  echo "14- Node Installed"
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get -qq install npm -y > /dev/null 2>&1 && \
  echo "15- Npm Installed"
sudo npm install -g --silent grunt-cli > /dev/null 2>&1 && \
  echo "16- Grunt Cli Installed"
sudo apt-get -qq install ruby-sass -y > /dev/null 2>&1 && \
  echo "17- Sass Installed"
echo "Bootstrap complete!"

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
sudo apt-get -y install php5.6 php5.6-mcrypt php5.6-mbstring php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl php5.6-sqlite3 php5.6-xdebug php5.6-soap > /dev/null 2>&1 && \
  echo "2 - PHP 5.6 Installed"

# Install Mysql 5.6 / Default password for root: password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

sudo apt-get -y -q install mysql-server-5.6 > /dev/null 2>&1 && \
  echo "3 - Mysql 5.6 Installed"

# Install JAVA
sudo apt-get -qq install openjdk-7-jre -y > /dev/null 2>&1 && \
  echo "4 - Java 7 Installed"

# Install SendMail
sudo apt-get -y install sendmail > /dev/null 2>&1 && \
  echo "5 - SendMail Installed"

# Install Git
sudo apt-get -y install git > /dev/null 2>&1 && \
  echo "6 - Git Installed"

# Install Unzip
sudo apt-get install unzip -y > /dev/null 2>&1 && \
  echo "7 - Unzip Installed"

# Install Elastic Search
cd /tmp
wget --quiet https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.1/elasticsearch-2.3.1.deb > /dev/null 2>&1
sudo dpkg -i elasticsearch-2.3.1.deb > /dev/null 2>&1 && \
sudo rm elasticsearch-2.3.1.deb && \
  echo "8 - Elasticsearch 2.3 Installed"

sudo cp /vagrant/vagrant/files/elasticsearch.yml /etc/elasticsearch/ && \
  echo "9 - Elasticsearch Configuration Copied "
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head > /dev/null 2>&1 && \
  echo "10- ES head plugin installed: http://vagrant.een.co.uk:9200/_plugin/head/"
# Add it as a service
sudo update-rc.d elasticsearch defaults 95 10 > /dev/null 2>&1
sudo /etc/init.d/elasticsearch start > /dev/null 2>&1
#systemd U16.04
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# /etc/hosts for VirtualHosts
cp /vagrant/vagrant/files/lamp.hosts /etc/hosts && \
  echo "11- Hosts File Copied"

# PHP.ini
cp /vagrant/vagrant/files/php.ini /etc/php/5.6/cli/php.ini && \
  echo "12- php.ini Copied"

# my.cnf
cp /vagrant/vagrant/files/my.cnf /etc/mysql/my.cnf && \
  echo "13- my.cnf Copied"

# Create folder and symlinks for virtualhost
sudo mkdir /home/web
sudo chown vagrant:vagrant /home/web
ln -s /var/www/een /home/web
ln -s /var/www/een-service /home/web

# Disable default vhost
sudo a2dissite 000-default > /dev/null 2>&1
sudo a2dissite default-ssl > /dev/null 2>&1
sudo a2enmod rewrite > /dev/null 2>&1

# Add ServerName to apache conf
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn > /dev/null 2>&1

# Restart Apache
service apache2 restart > /dev/null 2>&1 && \
  echo "14- Apache Configured"

# Copy bash_profile
cp /vagrant/vagrant/files/bash_profile /home/vagrant/.bash_profile && chown vagrant:vagrant /home/vagrant/.bash_profile && \
echo "
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi" >> /home/vagrant/.bashrc && \
  echo "15- .bash_profile vagrant Copied"

sudo cp /vagrant/vagrant/files/bash_profile /root/.bash_profile && sudo chown root:root /root/.bash_profile && \
sudo echo "
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi" >> /root/.bashrc && \
  echo "16- .bash_profile root Copied"

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" > /dev/null 2>&1 && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  > /dev/null 2>&1 && \
php composer-setup.php > /dev/null 2>&1 && \
php -r "unlink('composer-setup.php');" > /dev/null 2>&1 && \
sudo mv composer.phar /usr/bin/composer && \
  echo "17- Composer Installed"

# Nodejs, npm and grunt and all required binaries to use grunt and sass
sudo apt-get -qq install nodejs -y > /dev/null 2>&1 && \
  echo "18- Node Installed"
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get -qq install npm -y > /dev/null 2>&1 && \
  echo "19- Npm Installed"
sudo npm install -g --silent gulp-cli > /dev/null 2>&1 && \
  echo "20- Gulp Cli Installed"
sudo apt-get -qq install ruby-sass -y > /dev/null 2>&1 && \
  echo "21- Sass Installed"
echo "Bootstrap complete!"

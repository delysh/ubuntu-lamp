#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
HOMEDIRFOLDER='www'
PROJECTFOLDER='projects'

# create project folder
if [ -d "/var/www/html/${HOMEDIRFOLDER}" ];
then
	echo "/var/www/html/${HOMEDIRFOLDER} exists."
else
	sudo mkdir "/var/www/html/${HOMEDIRFOLDER}"
fi

if [ -d "/var/www/html/${PROJECTFOLDER}" ];
then
	echo "/var/www/html/${PROJECTFOLDER} exists."
else
	sudo mkdir "/var/www/html/${PROJECTFOLDER}"
fi

echo "<?php phpinfo(); ?>" > /var/www/html/${HOMEDIRFOLDER}/index.php

# install PPA 'ondrej/php'. The PPA is well known, and is relatively safe to use.
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
# install PPA maintained by phpMyAdmin team members for newer version of phpMyAdmin (doesn't always work).
#sudo add-apt-repository -y ppa:phpmyadmin/ppa

# update / upgrade
sudo apt -y update
sudo apt -y upgrade

# install apache
echo "INSTALLING APACHE"
sudo apt install -y apache2

# removing all old php dependencies (not needed on fresh setup).
#sudo apt-get remove -y php*

# installing php and php modules
echo "INSTALLING PHP"
sudo apt install -y php php-cli php-common libapache2-mod-php php-fpm php-curl php-gd php-bz2 php-json php-tidy php-mbstring php-redis php-memcached php-sqlite3 php-xml php-zip php-readline php-intl php-bcmath php-xmlrpc php-imagick php-mysql

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

## install phpmyadmin and give password(s) to installer
## for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
#

# install mysql and give password to installer
echo "INSTALLING MySQL"
sudo apt install -y mysql-server

echo "INSTALLING PHPMyAdmin"
sudo apt install -y phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${HOMEDIRFOLDER}"
    <Directory "/var/www/html/${HOMEDIRFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
sudo systemctl restart apache2
# restart mysql
sudo systemctl restart mysql

# install git
sudo apt install -y git

# install Composer
#sudo apt install -y composer
curl -sS https://getcomposer.org/installer |php
sudo mv composer.phar /usr/local/bin/composer

# install NodeJS and NPM
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# install yarn
npm install -g yarn

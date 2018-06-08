#!/bin/bash

# ---------------------------------------
#          Virtual Machine Setup
# ---------------------------------------

# Adding multiverse sources.
# cat > /etc/apt/sources.list.d/multiverse.list << EOF
# deb http://archive.ubuntu.com/ubuntu xenial multiverse
# deb http://archive.ubuntu.com/ubuntu xenial-updates multiverse
# deb http://security.ubuntu.com/ubuntu xenial-security multiverse
# EOF

# add-apt-repository ppa:ondrej/php
# Updating packages
apt-get update

# ---------------------------------------
#          Apache Setup
# ---------------------------------------

# Installing Packages
apt-get install -y apache2 libapache2-mod-fastcgi

# linking Vagrant directory to Apache 2.4 public directory

# Add ServerName to httpd.conf
echo "ServerName localhost" > /etc/apache2/httpd.conf
# Setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-enabled/000-default.conf

# Loading needed modules to make apache work
a2enmod actions fastcgi rewrite
service apache2 reload

# ---------------------------------------
#          PHP Setup
# ---------------------------------------

# Installing packages 7.0
apt-get install -y \
    php7.0 \
    php7.0-cli \
    php7.0-common \
    php7.0-json \
    php7.0-opcache \
    php7.0-mysql \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-zip \
    php7.0-fpm \
    php7.0-curl \
	php7.0-dev \
    php7.0-gd \
	php7.0-interbase \
    php7.0-mysql \
    php7.0-opcache \
    php7.0-xsl \
    php7.0-bcmath

apt-get install php-mongodb php-redis php-pear php-xdebug -y
# # Creating the configurations inside Apache
cat > /etc/apache2/conf-available/php7.0-fpm.conf << EOF
<IfModule mod_fastcgi.c>
    AddHandler php7-fcgi .php
    Action php7-fcgi /php7-fcgi
    Alias /php7-fcgi /usr/lib/cgi-bin/php7-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php7-fcgi -socket /var/run/php/php7.0-fpm.sock -pass-header Authorization

    # NOTE: using '/usr/lib/cgi-bin/php5-cgi' here does not work,
    #   it doesn't exist in the filesystem!
    <Directory /usr/lib/cgi-bin>
        Require all granted
    </Directory>

</IfModule>
EOF

# # Enabling php modules
# php5enmod mcrypt

# Triggering changes in apache
a2enconf php7.0-fpm
service apache2 reload

# ---------------------------------------
#          MySQL Setup
# ---------------------------------------

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Installing packages
#apt-get install -y mysql-server mysql-client php5-mysql
apt-get install -y mysql-server mysql-client

# ---------------------------------------
#          PHPMyAdmin setup
# ---------------------------------------

# Default PHPMyAdmin Settings
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

# Install PHPMyAdmin
apt-get install -y phpmyadmin

# Make Composer available globally
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-enabled/phpmyadmin.conf

# Restarting apache to make changes
service apache2 restart



# ---------------------------------------
#       Tools Setup.
# ---------------------------------------
# These are some extra tools that you can remove if you will not be using them 
# They are just to setup some automation to your tasks. 

# Adding NodeJS from Nodesource. This will Install NodeJS Version 5 and npm
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

# Installing GIT
apt-get install -y git

# Install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
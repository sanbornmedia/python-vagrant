#!/bin/bash

echo "Provisioning virtual machine..."

apt-get update -y

# Git
echo "Installing Git"
apt-get install git -y > /dev/null

# Nginx
echo "Installing Nginx"
apt-get install nginx -y > /dev/null

echo "Installing Python"
apt-get install python -y > /dev/null

apt-get install python-pip -y
apt-get install python-dev -y
apt-get install libxml2 libxml2-dev libxslt1-dev -y
apt-get install zlib1g-dev  -y
apt-get install uwsgi uwsgi-plugin-python -y

# MySQL 
echo "Preparing MySQL"
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"

echo "Installing MySQL"
apt-get install mysql-server -y > /dev/null
apt-get install libmysqlclient-dev -y > /dev/null


echo "Installing python modules"
pip install -r /var/www/src/pip_requirements.txt


# Nginx Configuration
echo "Configuring Nginx"
cp /var/www/provision/config/nginx_vhost /etc/nginx/sites-available/nginx_vhost > /dev/null
ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/

rm -rf /etc/nginx/sites-available/default

# Restart Nginx for the config to take effect
service nginx restart > /dev/null


echo "Initializing database"
mysql -p1234 < /var/www/provision/createdb.sql

echo "Migrating database"
python /var/www/src/manage.py syncdb 
python /var/www/src/manage.py migrate 

echo "Starting app"
ln -s /var/www/src/tripscanner/nginx/django.ini /etc/uwsgi/apps-enabled/
service uwsgi restart

echo "Finished provisioning."

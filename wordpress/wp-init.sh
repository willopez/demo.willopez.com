#!/bin/bash
SITEURL="http://admindemo.willopez.local"
getopts e: option

if [ "${OPTARG}" == "prod" ]; then 
  SITEURL="https://admindemo.willopez.com"
fi

# Perform WordPress installation
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress db reset --yes
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress core install --url=${SITEURL} --title="Demo Admin" --admin_user=admin --admin_password=admin --admin_email=example@demo.willopez.com

# Create default pages
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress post create --post_type=page --post_title='Home' --post_name='home' --post_content='Welcome to NoomaPress' --post_status='publish'
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress post create --post_type=page --post_title='About' --post_name='about' --post_content='About...' --post_status='publish'

# Install plugins and themes
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress plugin install gutenberg wp-stateless redirection disable-blogging white-label-cms redis-cache https://github.com/willopez/fancy-admin-ui/archive/master.zip --activate --force
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress theme install twentyseventeen --activate

# Delete unnecessary plugins and themes
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress plugin delete hello akismet
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress theme delete twentyfifteen twentysixteen

# Set url structure
docker exec admindemo.willopez.com wp --path=/usr/src/wordpress rewrite structure '/%postname%' --hard

# Fix permissions
docker exec admindemo.willopez.com chown -R nobody.nobody /var/www/wp-content

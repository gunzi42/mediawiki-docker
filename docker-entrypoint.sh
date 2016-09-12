#!/bin/bash

# Chown volumes so that apache can read/write
chown -R www-data:www-data /var/www/html/images
chown -R www-data:www-data /var/www/html/extensions/

if [ -f /var/www/html/LocalSettings.php ]
then
    chown www-data:www-data /var/www/html/LocalSettings.php
fi

exec "$@"

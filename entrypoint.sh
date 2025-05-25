#!/bin/bash

# Run the Nextcloud install if config/config.php does not exist
if [ ! -f /var/www/html/config/config.php ]; then
  echo "Installing Nextcloud..."
  sudo -E -u www-data php occ maintenance:install \
    --database="mysql" \
    --database-name="nextcloud" \
    --database-user="nextcloud" \
    --database-pass="${DB_PASS}" \
    --database-host="mysql" \
    --admin-user="nextcloud" \
    --admin-pass="nextcloud" 
else
  echo "Nextcloud already installed."
fi

# Disable the trusted domains check by modifying config.php (for testing)
#sed -i "s/'trusted_domains' => array()/&,\n  0 => 'localhost',\n  1 => '127.0.0.1',\n  2 => '192.168.68.201'/g" /var/www/html/nextcloud/config/config.php

sed -i "/'trusted_domains' =>/,/),/s/),/  1 => '127.0.0.1',\n  2 => '192.168.68.201',\n),/" /var/www/html/nextcloud/config/config.php



# Start the actual service (Apache or PHP-FPM)
exec "$@"


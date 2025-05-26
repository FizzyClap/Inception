#!/bin/sh

# Wait for MariaDB to be ready
echo "⏳ Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    sleep 2
done
echo "✅ MariaDB is ready."

# Create wp-config.php if missing
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "🔧 Creating wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="mariadb" \
        --dbprefix="wp_" \
        --path=/var/www/html \
        --allow-root
    echo "✅ wp-config.php created."
fi

# Install WordPress if not installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "🚀 Installing WordPress..."
    wp core install \
        --url="roespici.42.fr" \
        --title="Mon Site" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_MAIL}" \
        --path=/var/www/html \
        --allow-root
    echo "✅ WordPress installed."

    wp user create "${WORDPRESS_EDITOR_USER}" "${WORDPRESS_EDITOR_MAIL}" \
    --role=editor \
    --user_pass="${WORDPRESS_EDITOR_PASSWORD}" \
    --path=/var/www/html
fi


# Start php-fpm in the foreground (do NOT use --nodae, use --nodaemonize)
echo "🔧 Starting PHP-FPM..."
exec php-fpm82 --nodaemonize

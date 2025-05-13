#!/bin/sh

# Attendre que la base de données soit prête avant de configurer WordPress
echo "⏳ En attente de la base de données..."
until mysqladmin ping --silent; do
    sleep 1
done
echo "✅ Base de données prête."

# Création du fichier wp-config.php si nécessaire
if [ ! -f wp-config.php ]; then
    echo "🔧 Création du fichier wp-config.php..."

    cp wp-config-sample.php wp-config.php

    # Remplacer les placeholders avec les variables d'environnement
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" wp-config.php

    # Optionnel : Définir le salage des clés de sécurité
    sed -i "s/put your unique phrase here/$WORDPRESS_SECRET_KEY/" wp-config.php

    echo "✅ Fichier wp-config.php créé et configuré."
fi

# Lancer PHP-FPM en mode premier plan
echo "🔧 Lancement de PHP-FPM..."
exec php-fpm -F

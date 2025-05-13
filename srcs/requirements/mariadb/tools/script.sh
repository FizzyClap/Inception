#!/bin/sh

# 1. Démarrer le serveur MariaDB en arrière-plan
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialiser la base de données si nécessaire
if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Démarrer MariaDB en background
mysqld --user=mysql --datadir=/var/lib/mysql &

# Attendre que le serveur soit prêt
until mysqladmin ping --silent; do
    echo "⏳ En attente du démarrage de MariaDB..."
    sleep 1
done

# 2. Exécuter tes commandes mysql
echo "✅ MariaDB est prêt, exécution des commandes..."
mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;" || echo "Error while creating the database."
mysql -e "CREATE USER IF NOT EXISTS '\`$DB_USER\`'@'%' IDENTIFIED BY '$DB_PASSWORD';" || echo "Error while creating the user."
mysql -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '\`$DB_USER\`'@'%';" || echo "Error while giving rights to the user."
mysql -e "FLUSH PRIVILEGES;"

# 3. Garder le conteneur en vie
wait

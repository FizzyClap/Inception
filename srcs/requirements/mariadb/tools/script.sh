#!/bin/sh

# 1. Préparer le dossier pour le socket MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 750 /run/mysqld

# 2. Initialiser la base de données si ce n'est pas encore fait
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "📦 Initialisation de MariaDB..."
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null
fi

# 3. Lancer MariaDB temporairement pour initialisation
echo "🚀 Lancement temporaire de MariaDB..."
mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql &
pid="$!"

# 4. Attendre que le serveur MariaDB soit prêt
until mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent; do
    echo "⏳ En attente du démarrage de MariaDB..."
    sleep 1
done

# 5. Création de la base et de l'utilisateur
echo "✅ MariaDB est prêt, exécution des commandes..."

mysql --socket=/run/mysqld/mysqld.sock <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

# 6. Stopper l'instance temporaire
mysqladmin --socket=/run/mysqld/mysqld.sock shutdown

# 7. Lancer MariaDB "finalement"
exec /usr/bin/mysqld --user=mysql --console
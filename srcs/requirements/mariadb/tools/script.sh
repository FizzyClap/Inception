#!/bin/bash

mysql -u root -p"$ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
mysql -u root -p"$ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p"$ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';"
mysql -u root -p"$ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

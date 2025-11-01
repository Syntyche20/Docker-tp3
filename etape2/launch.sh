#!/bin/bash

# Supprimer tous les containers
docker rm -f $(docker ps -aq) 2>/dev/null

# Créer le réseau s'il n'existe pas
docker network inspect tp3-network >/dev/null 2>&1 || docker network create tp3-network

# Chemins absolus
srcPath="$(pwd)/src"
configPath="$(pwd)/config/default.conf"
dbPath="$(pwd)/db"
phpPath="$(pwd)/php"

# MariaDB
docker run -d --name data --network tp3-network \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v "$dbPath:/docker-entrypoint-initdb.d" \
  mariadb:latest

# Construire PHP avec mysqli
docker build -t php-mysqli "$phpPath"

# PHP-FPM
docker run -d --name script --network tp3-network \
  -v "$srcPath:/app" \
  php-mysqli

# Nginx
docker run -d --name http --network tp3-network -p 8080:80 \
  -v "$srcPath:/app" \
  -v "$configPath:/etc/nginx/conf.d/default.conf" \
  nginx:latest

echo "Etape 2 lancée. Vérifier http://localhost:8080/ et http://localhost:8080/test.php"

#!/bin/bash

# Supprimer les containers existants
docker rm -f script http 2>/dev/null

# Créer le réseau Docker s'il n'existe pas
if ! docker network inspect tp3-network >/dev/null 2>&1; then
    docker network create tp3-network
fi

# Lancer le container PHP-FPM
docker run -d \
  --name script \
  --network tp3-network \
  -v "$(pwd)/src":/app \
  php:8.2-fpm

# Lancer le container Nginx
docker run -d \
  --name http \
  --network tp3-network \
  -p 8080:80 \
  -v "$(pwd)/src":/app \
  -v "$(pwd)/config/default.conf":/etc/nginx/conf.d/default.conf \
  nginx:latest

echo "Containers lancés. Ouvrir http://localhost:8080/ pour vérifier phpinfo()"

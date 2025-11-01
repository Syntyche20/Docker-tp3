#!/bin/bash

# Supprimer tous les containers
docker rm -f $(docker ps -aq) 2>/dev/null

# Créer le réseau Docker s'il n'existe pas
docker network inspect tp3-network >/dev/null 2>&1 || docker network create tp3-network

# Chemins absolus
srcPath="$(pwd)/src"
configPath="$(pwd)/config/default.conf"

# Lancer PHP-FPM
docker run -d --name script --network tp3-network -v "$srcPath:/app" php:8.2-fpm

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 \
  -v "$srcPath:/app" \
  -v "$configPath:/etc/nginx/conf.d/default.conf" \
  nginx:latest

echo "Containers lancés. Ouvrir http://localhost:8080/ pour vérifier phpinfo()"

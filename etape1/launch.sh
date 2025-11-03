#!/bin/bash

# Supprimer tous les containers existants
docker rm -f $(docker ps -aq) 2>/dev/null

# Créer le réseau Docker s'il n'existe pas
docker network inspect tp3-network >/dev/null 2>&1 || docker network create tp3-network

# Chemins Windows -> format Linux pour Docker
SRC_PATH="$(pwd | sed 's|\\|/|g' | sed 's|^\([A-Za-z]\):|/\L\1|')/src"
CONFIG_PATH="$(pwd | sed 's|\\|/|g' | sed 's|^\([A-Za-z]\):|/\L\1|')/config/default.conf"

# Vérification des fichiers
if [ ! -d "$SRC_PATH" ]; then
    echo "Erreur : dossier src introuvable"
    exit 1
fi
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Erreur : config/default.conf introuvable"
    exit 1
fi

# Lancer PHP-FPM
docker run -d --name script --network tp3-network -v "$SRC_PATH:/app:ro" php:8.2-fpm

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 \
  -v "$SRC_PATH:/app:ro" \
  -v "$CONFIG_PATH:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "Containers lancés. Ouvrir http://localhost:8080/"

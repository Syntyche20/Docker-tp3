# Supprimer anciens containers
docker rm -f data
docker rm -f script
docker rm -f http

# Créer le réseau
docker network create tp3-network -d bridge 2>$null

# Lancer MariaDB
docker run -d --name data --network tp3-network -e MARIADB_RANDOM_ROOT_PASSWORD=yes -v ./db:/docker-entrypoint-initdb.d mariadb:latest

# Construire PHP avec mysqli
docker build -t php-mysqli ./php

# Lancer PHP-FPM
docker run -d --name script --network tp3-network -v ./src:/app php-mysqli

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 -v ./src:/app -v ./config/default.conf:/etc/nginx/conf.d/default.conf nginx:latest

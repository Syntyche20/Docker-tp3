# Supprimer anciens containers
docker rm -f data 2>$null
docker rm -f script 2>$null
docker rm -f http 2>$null

# Créer le réseau s'il n'existe pas
docker network inspect tp3-network 2>$null || docker network create tp3-network

# Lancer MariaDB
docker run -d --name data --network tp3-network `
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes `
  -v ./db:/docker-entrypoint-initdb.d `
  mariadb:latest

# Construire PHP avec mysqli
docker build -t php-mysqli ./php

# Lancer PHP-FPM
docker run -d --name script --network tp3-network `
  -v ./src:/app `
  php-mysqli

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 `
  -v ./src:/app `
  -v ./config/default.conf:/etc/nginx/conf.d/default.conf `
  nginx:latest

Write-Host "Etape 2 lancée. Vérifier http://localhost:8080/ et http://localhost:8080/test.php"

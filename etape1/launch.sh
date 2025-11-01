# Supprimer les containers existants
docker rm -f script http 2>$null

# Créer le réseau Docker s'il n'existe pas
docker network inspect tp3-network 2>$null || docker network create tp3-network

# Lancer le container PHP-FPM
docker run -d --name script --network tp3-network -v ./src:/app php:8.2-fpm

# Lancer le container Nginx
docker run -d --name http --network tp3-network -p 8080:80 `
  -v ./src:/app `
  -v ./config/default.conf:/etc/nginx/conf.d/default.conf `
  nginx:latest

Write-Host "Containers lancés. Ouvrir http://localhost:8080/ pour vérifier phpinfo()"

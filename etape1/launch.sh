# -----------------------------
# Launch.ps1 - Etape 1
# -----------------------------

# Supprimer tous les containers existants
docker rm -f $(docker ps -aq) 2>$null

# Créer le réseau Docker s'il n'existe pas
docker network inspect tp3-network 2>$null || docker network create tp3-network

# Définir les chemins absolus Windows
$srcPath = "$PWD\src"
$configPath = "$PWD\config\default.conf"

# Lancer PHP-FPM
docker run -d --name script --network tp3-network -v "$srcPath:/app" php:8.2-fpm

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 `
  -v "$srcPath:/app" `
  -v "$configPath:/etc/nginx/conf.d/default.conf" `
  nginx:latest

Write-Host "Containers lancés. Ouvrir http://localhost:8080/ pour vérifier phpinfo()"

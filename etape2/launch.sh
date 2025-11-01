# -----------------------------
# Launch.ps1 - Etape 2
# -----------------------------

# Supprimer tous les containers existants
docker rm -f $(docker ps -aq) 2>$null

# Créer le réseau Docker s'il n'existe pas
docker network inspect tp3-network 2>$null || docker network create tp3-network

# Définir les chemins absolus Windows
$srcPath = "$PWD\src"
$configPath = "$PWD\config\default.conf"
$dbPath = "$PWD\db"
$phpPath = "$PWD\php"

# Lancer MariaDB
docker run -d --name data --network tp3-network `
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes `
  -v "$dbPath:/docker-entrypoint-initdb.d" `
  mariadb:latest

# Construire l'image PHP avec mysqli
docker build -t php-mysqli "$phpPath"

# Lancer PHP-FPM
docker run -d --name script --network tp3-network `
  -v "$srcPath:/app" `
  php-mysqli

# Lancer Nginx
docker run -d --name http --network tp3-network -p 8080:80 `
  -v "$srcPath:/app" `
  -v "$configPath:/etc/nginx/conf.d/default.conf" `
  nginx:latest

Write-Host "Etape 2 lancée. Vérifier http://localhost:8080/ et http://localhost:8080/test.php"

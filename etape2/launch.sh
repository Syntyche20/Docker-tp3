#!/bin/bash
export MSYS_NO_PATHCONV=1

# 🔹 Obtenir le chemin du script (portable)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 🔹 Définir les chemins relatifs
srcPath="$SCRIPT_DIR/src"
configPath="$SCRIPT_DIR/config/default.conf"
dbPath="$SCRIPT_DIR/db"
phpPath="$SCRIPT_DIR/php"

# 🔹 Vérification des dossiers/fichiers
if [ ! -d "$srcPath" ]; then
    echo "❌ Erreur : dossier src introuvable"
    echo "Chemin attendu : $srcPath"
    exit 1
fi

if [ ! -f "$configPath" ]; then
    echo "❌ Erreur : config/default.conf introuvable"
    echo "Chemin attendu : $configPath"
    exit 1
fi

if [ ! -d "$dbPath" ]; then
    echo "❌ Erreur : dossier db introuvable"
    echo "Chemin attendu : $dbPath"
    exit 1
fi

if [ ! -d "$phpPath" ]; then
    echo "❌ Erreur : dossier php introuvable"
    echo "Chemin attendu : $phpPath"
    exit 1
fi

# 🔹 Supprimer tous les containers existants
docker rm -f $(docker ps -aq) 2>/dev/null

# 🔹 Créer le réseau Docker si inexistant
docker network inspect tp3-network >/dev/null 2>&1 || docker network create tp3-network

# =======================
# 1️⃣ Container DATA (MariaDB)
# =======================
docker run -d --name data --network tp3-network \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v "$dbPath:/docker-entrypoint-initdb.d" \
  mariadb:latest

echo "⏳ Attente 15s pour MariaDB..."
sleep 15
echo "✅ MariaDB initialisée."

# =======================
# 2️⃣ Container SCRIPT (PHP-FPM)
# =======================
# Construire l'image PHP avec mysqli
PHP_PATH_WIN=$(cd "$phpPath" && pwd -W)
docker build -t php-mysqli "$PHP_PATH_WIN"

docker run -d --name script --network tp3-network \
  -v "$srcPath:/app" \
  php-mysqli

# =======================
# 3️⃣ Container HTTP (Nginx)
# =======================
docker run -d --name http --network tp3-network -p 8080:80 \
  -v "$srcPath:/app" \
  -v "$configPath:/etc/nginx/conf.d/default.conf" \
  nginx:latest

echo "✅ Étape 2 lancée !"
echo "➡️  Vérifier la page : http://localhost:8080/test.php"

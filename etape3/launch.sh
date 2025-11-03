#!/bin/bash
export MSYS_NO_PATHCONV=1

docker rm -f $(docker ps -aq) 2>/dev/null
# Obtenir le chemin du script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Vérification des dossiers importants
for dir in src config db php; do
    if [ ! -d "$dir" ]; then
        echo "❌ Erreur : dossier $dir introuvable"
        exit 1
    fi
done

if [ ! -f config/default.conf ]; then
    echo "❌ Erreur : config/default.conf introuvable"
    exit 1
fi

# Supprimer les anciens containers et volumes
docker-compose down -v

# Lancer tous les services en arrière-plan
docker-compose up -d --build

echo "✅ Etape 3 lancée."
echo "Vérifier les pages :"
echo "  http://localhost:8080/        -> phpinfo()"
echo "  http://localhost:8080/test.php -> CRUD MariaDB"

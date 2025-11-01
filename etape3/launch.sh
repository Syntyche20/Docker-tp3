# Etape 3 - launch.ps1

# Se placer dans le répertoire de l'étape

# Supprimer les anciens containers et volumes liés
docker-compose down -v

# Lancer tous les services en détaché
docker-compose up -d

Write-Host "Etape 3 lancée."
Write-Host "Vérifier les pages :"
Write-Host "  http://localhost:8080/        -> phpinfo()"
Write-Host "  http://localhost:8080/test.php -> CRUD MariaDB"

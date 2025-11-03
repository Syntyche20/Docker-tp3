# 🐳 Docker TP3

## 🧩 Description
Ce projet a pour objectif de mettre en pratique la création et la gestion de conteneurs Docker à travers trois étapes progressives.  
L’objectif final est de maîtriser la mise en place d’un environnement web complet : **PHP-FPM + Nginx + MariaDB**, puis de le gérer via **Docker Compose**.

### Les étapes :
1. **Étape 1 :** Serveur PHP-FPM + Nginx  
2. **Étape 2 :** Ajout d’une base de données **MariaDB** et installation de l’extension **mysqli** pour PHP  
3. **Étape 3 :** Conversion du projet en configuration **Docker Compose**

---

## ⚙️ Instructions pour lancer le TP

### 🧰 Prérequis
Avant de commencer, assure-toi d’avoir :
- **Docker** installé (version ≥ 20.10)
- Un terminal compatible Bash / PowerShell
- **Git** installé pour cloner le dépôt

### 📦 Cloner et lancer le projet

```bash
git clone https://github.com/Syntyche20/Docker-tp3.git
cd Docker-tp3

bash etape1/launch.sh
bash etape2/launch.sh
bash etape3/launch.sh

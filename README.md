# Documentation d’utilisation

Prérequis: il faut avoir installé git + docker + compose + make
`apt install make`

## 1. Préparation de l’environnement

1. **Cloner ce dépôt** (si ce n’est pas déjà fait) :
   ```sh
   git clone <url-du-repo> && cd developper-module
   ```

2. **Cloner le plugin en développement** dans le dossier `plugins` :
   ```sh
   cd plugins
   git clone <url-du-plugin>
   cd ..
   ```

## 2. Gestion des conteneurs Docker

Toutes les commandes suivantes se lancent depuis la racine du projet (`developper-module`).

- **Renommer les conteneurs et volumes** (optionnel, pour personnaliser le préfixe) :
  ```sh
  make rename-containers CONTAINER_PREFIX=template PORT=53000 MYSQL_PASSWORD=monmotdepasse 
  ```

- **Démarrer l’environnement** :
  ```sh
  make up
  ```

- **Arrêter l’environnement** :
  ```sh
  make down
  ```

- **Arrêter les conteneurs sans les supprimer** :
  ```sh
  make stop
  ```

- **Mettre à jour les images et relancer** :
  ```sh
  make update
  ```

- **Afficher les logs** :
  ```sh
  make logs
  ```

- **Ouvrir un shell dans un conteneur** (par défaut dans jeedom_http) :
  ```sh
  make shell
  # ou dans un autre service :
  make shell SERVICE=jeedom_db
  ```

- **Exécuter une commande dans un conteneur** :
  ```sh
  make exec SERVICE=jeedom_http CMD="ls -l /var/www/html"
  ```

- **Ouvrir un shell dans le conteneur HTTP automatiquement** :
  ```sh
  make shell
  ```
  (le Makefile utilise automatiquement le bon nom de conteneur grâce à la variable SERVICE_HTTP du .env)

- **Exécuter une commande dans le conteneur HTTP automatiquement** :
  ```sh
  make exec CMD="ls -l /var/www/html"
  ```
  (inutile de préciser SERVICE, le Makefile le détecte automatiquement)

- **Utiliser automatiquement le nom du conteneur HTTP** :
  Pour exécuter une commande ou ouvrir un shell dans le conteneur HTTP sans avoir à connaître son nom, tu peux utiliser la variable SERVICE_HTTP générée dans le fichier `.env` :
  ```sh
  make shell SERVICE=$(shell grep SERVICE_HTTP .env | cut -d= -f2)
  # ou pour exécuter une commande :
  make exec SERVICE=$(shell grep SERVICE_HTTP .env | cut -d= -f2) CMD="ls -l /var/www/html"
  ```
  Cette variable est automatiquement mise à jour à chaque `make rename-containers` selon le préfixe choisi.

## 3. Variables utiles

- `CONTAINER_PREFIX` : permet de personnaliser le nom des conteneurs et volumes (par défaut : jeedom).

## 4. Configuration du mot de passe MySQL

Lors de l'exécution de la commande `make rename-containers`, le mot de passe MySQL utilisé dans le fichier `docker-compose.yml` peut être défini de plusieurs façons :

- **Définir manuellement le mot de passe** :
  ```sh
  make rename-containers MYSQL_PASSWORD=tonmotdepasse
  ```
- **Laisser le Makefile générer un mot de passe sécurisé aléatoire** :
  Si tu ne précises pas la variable `MYSQL_PASSWORD`, un mot de passe fort sera généré automatiquement et affiché dans le terminal.

Ce mot de passe sera utilisé pour :
- `MYSQL_ROOT_PASSWORD` (service MariaDB)
- `MYSQL_PASSWORD` (service MariaDB)
- `DB_PASSWORD` (service Jeedom)

Pense à le conserver si tu veux te connecter à la base de données manuellement.

---

Pour toute question ou contribution, n’hésite pas à ouvrir une issue ou une pull request.
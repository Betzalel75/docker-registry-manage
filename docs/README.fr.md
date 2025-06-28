

## 🇫🇷 `README.fr.md`


# 📦 docker-registry-manage

![Licence: MIT](https://img.shields.io/badge/license-MIT-blue)
![Shell Script](https://img.shields.io/badge/script-bash-yellow?logo=gnubash)

**docker-registry-manage** est un script Bash qui automatise la publication de plusieurs images Docker vers Docker Hub ou tout autre registre Docker compatible OCI (Open Container Initiative).

Il fournit une interface simple en ligne de commande pour :
- appliquer un tag à plusieurs images locales,
- les renommer selon une convention standard (nom d'utilisateur, registre, tag),
- les pousser en série avec suivi des erreurs,
- et vérifier l'état de Docker (connexion, service actif, etc.).

---

## 🧠 Fonctionnement technique

Le script exécute les étapes suivantes :

1. **Vérification de l’environnement** :
   - Présence de Docker (`command -v docker`)
   - Docker en cours d’exécution (`docker info`)
   - Authentification active (`docker info | grep Username`) ou utilisateur fourni

2. **Chargement des images** :
   - Par arguments positionnels (`image1 image2 ...`)
   - Ou à partir d’un fichier texte via `--file` (une image par ligne)

3. **Construction du nom complet de chaque image cible** :
  ```bash
   docker.io/<utilisateur>/<nom_image>:<tag>
  ````

4. **Tagging (re-étiquetage)** :

   * Utilise `docker tag` pour renommer chaque image locale vers le nom de destination

5. **Push** :

   * Utilise `docker push` pour chaque image
   * Affiche les succès/échecs dans un résumé final

6. **Mode dry-run** :

   * Simule les commandes `tag` et `push` sans exécution réelle

7. **Mode verbose** :

   * Affiche toutes les étapes internes avec plus de détails

---

## 🔧 Fonctionnement du script d'installation

Le script `install.sh` effectue les opérations suivantes :

1. **Téléchargement** : Récupère la dernière version du script `push-multiple-images.sh` depuis GitHub
2. **Installation** :
   - Place le script dans `~/.local/bin/` (créé si nécessaire)
   - Rend le script exécutable (`chmod +x`)
3. **Configuration** :
   - Ajoute un alias pratique `docker-push` dans votre fichier shell (`.bashrc`, `.zshrc` ou `.profile`)
   - Vérifie et évite les doublons si l'alias existe déjà
4. **Sécurité** :
   - Utilise `set -e` pour stopper en cas d'erreur
   - Vérifie que le téléchargement a réussi

Après installation, vous pouvez utiliser soit :

```bash
~/.local/bin/push-multiple-images.sh
```
Ou l'alias plus court :

```bash
docker-push
```
ℹ️ *Le script détecte automatiquement votre shell pour modifier le bon fichier de configuration.*
---

## 🚀 Utilisation

### Commande de base

```bash
docker-push -u monutilisateur image1 image2 image3
```

### Avec options :

* `--tag` pour spécifier un tag :

  ```bash
  docker-push -u monutilisateur -t v1.0 api gateway worker
  ```

* `--file` pour lire les images depuis un fichier :

  ```bash
  docker-push -u monutilisateur -f images.txt
  ```

* `--dry-run` pour tester sans rien exécuter :

  ```bash
  docker-push -n -u monutilisateur api billing frontend
  ```

---

## 📂 Exemple de fichier `images.txt`

```txt
api
auth
frontend
backend
```

---

## 🧹 Désinstallation

**curl :**

```bash
curl -fsSL https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

**wget :**

```bash
wget -qO- https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

---

## ✍️ Auteur

* **Betzalel75** – [GitHub](https://github.com/Betzalel75)

---

## 📄 Licence

Projet sous licence MIT.

---

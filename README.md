
# 📦 docker-registry-manage

![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Shell Script](https://img.shields.io/badge/script-bash-yellow?logo=gnubash)

**docker-registry-manage** is a simple shell utility to push multiple Docker images at once to Docker Hub or any other OCI-compatible registry.

**docker-registry-manage** est un utilitaire en shell qui permet de publier facilement plusieurs images Docker en une seule commande, vers Docker Hub ou n'importe quel registre compatible OCI.

---

## ⚙️ Installation

**via curl :**

```bash
curl -fsSL https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/install.sh | sh
````

**via wget :**

```bash
wget -qO- https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/install.sh | sh
```

---

## 🧹 Désinstallation / Uninstallation

**via curl :**

```bash
curl -fsSL https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

**via wget :**

```bash
wget -qO- https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

---

## 🚀 Usage / Utilisation

Once installed, you can use the command:

Une fois installé, utilisez la commande :

```bash
docker-push [OPTIONS] IMAGE1 IMAGE2 ... IMAGEN
```

To see available options:

Pour voir toutes les options disponibles :

```bash
docker-push --help
```

---

## 🌐 Language / Langue

For more details about the project, please read the README in your preferred language:

Pour plus de détails sur le projet, veuillez lire le README dans votre langue préférée :

* [English / Anglais](docs/README.en.md)
* [Français / French](docs/README.fr.md)

---

## 👤 Authors / Auteurs

* **Betzalel75** – [GitHub Profile](https://github.com/Betzalel75)

---

## 📄 License / Licence

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus d'informations.


---

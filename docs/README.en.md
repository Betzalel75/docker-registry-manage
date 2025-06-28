
## 🇬🇧 `README.en.md`


# 📦 docker-registry-manage

![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Shell Script](https://img.shields.io/badge/script-bash-yellow?logo=gnubash)

**docker-registry-manage** is a Bash script that automates the push of multiple Docker images to Docker Hub or any OCI-compliant registry.

It provides a convenient CLI to:
- tag multiple local images with a custom tag,
- rename them following a consistent naming pattern (username, registry, tag),
- push all images with success/error handling,
- verify Docker environment status (running, authenticated, etc.).

---

## 🧠 Technical Overview

The script follows these steps:

1. **Environment validation**:
   - Checks if Docker is installed (`command -v docker`)
   - Verifies Docker is running (`docker info`)
   - Verifies Docker Hub login (`docker info | grep Username`) or uses `--username`

2. **Image source loading**:
   - From command-line arguments (`image1 image2 ...`)
   - Or from a file via `--file` (one image name per line)

3. **Target image naming logic**:
  ```bash
   docker.io/<username>/<image_name>:<tag>
  ````

4. **Image tagging**:

   * Uses `docker tag` to rename each local image

5. **Pushing images**:

   * Uses `docker push` to upload images
   * Displays results in a final summary

6. **Dry-run mode**:

   * Simulates `tag` and `push` without executing them

7. **Verbose mode**:

   * Shows all internal processing steps with more details

---

## 🔧 Installation Script Functionality

The `install.sh` script performs the following operations:

1. **Download**:
   - Fetches the latest version of `push-multiple-images.sh` from GitHub
2. **Installation**:
   - Places the script in `~/.local/bin/` (creates directory if needed)
   - Makes the script executable (`chmod +x`)
3. **Configuration**:
   - Adds a convenient `docker-push` alias to your shell config file (`.bashrc`, `.zshrc` or `.profile`)
   - Checks for and prevents duplicate aliases
4. **Safety Features**:
   - Uses `set -e` to stop on errors
   - Verifies successful download

After installation, you can use either:

```bash
~/.local/bin/push-multiple-images.sh
```
Or the shorter alias:

```bash
docker-push
```

ℹ️ *The script automatically detects your shell to modify the correct configuration file.*

---

## 🚀 Usage

### Basic command

```bash
docker-push -u myusername image1 image2 image3
```

### With options:

* `--tag` to specify a tag:

  ```bash
  docker-push -u myusername -t v1.0 api gateway worker
  ```

* `--file` to read images from file:

  ```bash
  docker-push -u myusername -f images.txt
  ```

* `--dry-run` to simulate:

  ```bash
  docker-push -n -u myusername api billing frontend
  ```

---

## 📂 Example `images.txt`

```txt
api
auth
frontend
backend
```

---

## 🧹 Uninstall

**curl:**

```bash
curl -fsSL https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

**wget:**

```bash
wget -qO- https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/uninstall.sh | sh
```

---

## ✍️ Author

* **Betzalel75** – [GitHub](https://github.com/Betzalel75)

---

## 📄 License

This project is licensed under the MIT License.


---

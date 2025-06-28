#!/bin/bash

set -e

SCRIPT_NAME="push-multiple-images.sh"
ALIAS_NAME="docker-push"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/Betzalel75/docker-registry-manage/main/scripts/$SCRIPT_NAME"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Détection du shell utilisateur
detect_shell_rc() {
    local shell_name
    shell_name=$(basename "$SHELL")

    case "$shell_name" in
        bash)
            echo "$HOME/.bashrc"
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        sh)
            echo "$HOME/.profile"
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

add_alias_if_not_exists() {
    local rc_file="$1"
    local alias_line="alias $ALIAS_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\""

    if grep -Fxq "$alias_line" "$rc_file"; then
        echo -e "${YELLOW}[INFO] Alias déjà présent dans $rc_file${NC}"
    else
        echo "$alias_line" >> "$rc_file"
        echo -e "${GREEN}[OK] Alias ajouté à $rc_file${NC}"
    fi
}

download_script() {
    echo -e "${GREEN}[INFO] Téléchargement du script depuis GitHub...${NC}"
    if ! curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
        echo -e "${RED}[ERREUR] Échec du téléchargement du script${NC}" >&2
        exit 1
    fi
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
}

main() {
    echo -e "${GREEN}=== Installation de $SCRIPT_NAME ===${NC}"

    # Crée le dossier si nécessaire
    mkdir -p "$INSTALL_DIR"

    # Télécharge et installe le script
    download_script
    echo -e "${GREEN}[OK] Script installé dans $INSTALL_DIR${NC}"

    # Ajout de l'alias dans le bon fichier RC
    RC_FILE=$(detect_shell_rc)
    add_alias_if_not_exists "$RC_FILE"

    echo ""
    echo -e "${GREEN}✅ Installation terminée.${NC}"
    echo -e "${YELLOW}ℹ️  Redémarrez votre terminal ou exécutez :${NC} source $RC_FILE"
    echo -e "${YELLOW}➡️  Utilisez le script avec : ${NC}$ALIAS_NAME"
}

main
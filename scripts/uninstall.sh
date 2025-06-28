#!/bin/bash

set -e

SCRIPT_NAME="push-multiple-images.sh"
ALIAS_NAME="docker-push"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Couleurs pour une meilleure lisibilité
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Détection du shell
detect_shell_rc() {
    case "$(basename "$SHELL")" in
        bash) echo "$HOME/.bashrc" ;;
        zsh) echo "$HOME/.zshrc" ;;
        sh) echo "$HOME/.profile" ;;
        *) echo "$HOME/.profile" ;;
    esac
}

# Suppression de l'alias
remove_alias() {
    local rc_file="$1"
    # Version sécurisée du pattern pour sed
    local alias_pattern="alias $ALIAS_NAME=\"$INSTALL_PATH\""
    
    if [ ! -f "$rc_file" ]; then
        echo -e "${YELLOW}[INFO] Fichier $rc_file non trouvé${NC}"
        return
    fi

    if grep -Fxq "$alias_pattern" "$rc_file"; then
        # Solution plus portable que sed -i
        temp_file=$(mktemp)
        grep -Fvx "$alias_pattern" "$rc_file" > "$temp_file"
        mv "$temp_file" "$rc_file"
        echo -e "${GREEN}[OK] Alias supprimé de $rc_file${NC}"
    else
        echo -e "${YELLOW}[INFO] Alias non trouvé dans $rc_file${NC}"
    fi
}

# Suppression du script
remove_script() {
    if [ -f "$INSTALL_PATH" ]; then
        rm -f "$INSTALL_PATH"
        echo -e "${GREEN}[OK] Script supprimé de $INSTALL_PATH${NC}"
        
        # Supprime le répertoire s'il est vide
        if [ -z "$(ls -A "$INSTALL_DIR")" ]; then
            rmdir "$INSTALL_DIR"
            echo -e "${YELLOW}[INFO] Répertoire $INSTALL_DIR supprimé (vide)${NC}"
        fi
    else
        echo -e "${YELLOW}[INFO] Aucun script à supprimer à $INSTALL_PATH${NC}"
    fi
}

echo -e "${RED}=== Désinstallation de docker-registry-manage ===${NC}"
remove_script
remove_alias "$(detect_shell_rc)"
echo -e "${GREEN}[✅] Désinstallation terminée.${NC}"
echo -e "${YELLOW}ℹ️  Redémarrez votre terminal pour finaliser.${NC}"
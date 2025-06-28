#!/bin/bash

set -e

SCRIPT_NAME="push-multiple-images.sh"
ALIAS_NAME="docker-push"
INSTALL_PATH="$HOME/.local/bin/$SCRIPT_NAME"

# Détection du shell
detect_shell_rc() {
    case "$(basename "$SHELL")" in
        bash) echo "$HOME/.bashrc" ;;
        zsh) echo "$HOME/.zshrc" ;;
        sh) echo "$HOME/.profile" ;;
        *) echo "$HOME/.profile" ;;
    esac
}

# Suppression de l’alias
remove_alias() {
    local rc_file="$1"
    local alias_line="alias $ALIAS_NAME=\"$INSTALL_PATH\""
    if grep -Fxq "$alias_line" "$rc_file"; then
        sed -i "/$alias_line/d" "$rc_file"
        echo "[INFO] Alias supprimé de $rc_file"
    else
        echo "[INFO] Alias non trouvé dans $rc_file"
    fi
}

# Suppression du script
remove_script() {
    if [ -f "$INSTALL_PATH" ]; then
        rm -f "$INSTALL_PATH"
        echo "[INFO] Script supprimé de $INSTALL_PATH"
    else
        echo "[INFO] Aucun script à supprimer à $INSTALL_PATH"
    fi
}

echo "[...] Désinstallation de docker-registry-manage"
remove_script
remove_alias "$(detect_shell_rc)"
echo "[✅] Désinstallation terminée. Redémarrez votre terminal pour finaliser."

#!/bin/bash

# Script pour ouvrir une URL dans le navigateur Windows depuis WSL
# Usage: browser.sh <url>
# Exemple: browser.sh "https://google.com"

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <url>"
    echo "Exemple: $0 'https://google.com'"
    exit 1
fi

# Vérifier si on est dans WSL
if [[ -z "${WSL_DISTRO_NAME}" ]]; then
    echo "⚠️  Ce script est conçu pour WSL"
    echo "Utilisation du navigateur par défaut du système..."
    xdg-open "$1" 2>/dev/null || open "$1" 2>/dev/null || echo "❌ Impossible d'ouvrir l'URL"
else
    echo "🌐 Ouverture de $1 dans le navigateur Windows..."
    /mnt/c/Windows/System32/cmd.exe /c start "$1"
fi
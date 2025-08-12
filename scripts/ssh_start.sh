#!/bin/bash

# Script pour démarrer le service SSH sur Ubuntu/WSL
# Usage: ssh_start.sh

echo "🔐 Démarrage du service SSH..."

# Vérifier si SSH est installé
if ! command -v sshd &> /dev/null; then
    echo "❌ SSH n'est pas installé"
    echo "💡 Installation: sudo apt update && sudo apt install openssh-server"
    exit 1
fi

# Démarrer le service SSH
if sudo service ssh start; then
    echo "✅ Service SSH démarré avec succès"
    
    # Afficher l'IP pour les connexions
    if command -v hostname &> /dev/null; then
        local_ip=$(hostname -I | awk '{print $1}')
        echo "📡 IP locale: $local_ip"
        echo "🔗 Connexion: ssh $(whoami)@$local_ip"
    fi
    
    # Vérifier le statut
    if sudo service ssh status | grep -q "active (running)"; then
        echo "🟢 Statut: Actif"
    else
        echo "🟠 Statut: Vérifiez manuellement avec 'sudo service ssh status'"
    fi
else
    echo "❌ Échec du démarrage du service SSH"
    echo "💡 Vérifiez les logs: sudo journalctl -u ssh"
    exit 1
fi
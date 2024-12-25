#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_message() {
    echo -e "${GREEN}$1${NC}"
}

# Fonction pour installer un paquet
install_package() {
    if ! command -v $1 &> /dev/null; then
        print_message "Installation de $1..."
        sudo apt-get install -y $1
    else
        print_message "$1 est déjà installé."
    fi
}

# Mettre à jour les paquets
print_message "Mise à jour des paquets..."
sudo apt-get update && sudo apt-get upgrade -y

# Installer les logiciels nécessaires
install_package zsh
install_package git
install_package tmux
install_package curl
install_package build-essential

# Installer Go
if ! command -v go &> /dev/null; then
    print_message "Installation de Go..."
    sudo apt-get install -y golang
else
    print_message "Go est déjà installé."
fi

# Installer Rust et Cargo
if ! command -v cargo &> /dev/null; then
    print_message "Installation de Rust et Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    print_message "Rust et Cargo sont déjà installés."
fi

# Installer Node.js
if ! command -v node &> /dev/null; then
    print_message "Installation de Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    print_message "Node.js est déjà installé."
fi

# Installer Lua
install_package lua5.3
install_package liblua5.3-dev

# Installer Neovim depuis les sources
if ! command -v nvim &> /dev/null; then
    print_message "Installation de Neovim depuis les sources..."
    sudo apt-get install -y ninja-build gettext cmake unzip
    git clone https://github.com/neovim/neovim
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ..
    rm -rf neovim
else
    print_message "Neovim est déjà installé."
fi

# Installer Oh My Zsh si ce n'est pas déjà fait
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_message "Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    print_message "Oh My Zsh est déjà installé."
fi

# Créer les liens symboliques
print_message "Création des liens symboliques..."
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/.zshenv" "$HOME/.zshenv"
ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"
ln -sf "$PWD/.gitignore" "$HOME/.gitignore"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.p10k.zsh" "$HOME/.p10k.zsh"

# Copier les dossiers
print_message "Copie des dossiers..."
if [ -d ".config" ]; then
    cp -r .config "$HOME/"
else
    echo "Le dossier .config n'existe pas dans le répertoire courant."
fi

# Copier Oh My Zsh personnalisé
print_message "Copie de la configuration Oh My Zsh personnalisée..."
if [ -d "$HOME/.oh-my-zsh" ] && [ -d ".oh-my-zsh/custom" ]; then
    cp -r .oh-my-zsh/custom/* "$HOME/.oh-my-zsh/custom/"
else
    echo "Oh My Zsh n'est pas installé ou le dossier custom n'existe pas."
fi

# Changer le shell par défaut pour Zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    print_message "Changement du shell par défaut pour Zsh..."
    chsh -s $(which zsh)
fi

print_message "Installation terminée ! Redémarrez votre terminal ou exécutez 'source ~/.zshrc' pour appliquer les changements."


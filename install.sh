#!/bin/bash

# Dotfiles Installer - Version améliorée avec gestion des secrets
# Usage: ./install.sh [--skip-wakatime] [--backup]

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
SKIP_WAKATIME=false
CREATE_BACKUP=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-wakatime)
            SKIP_WAKATIME=true
            shift
            ;;
        --backup)
            CREATE_BACKUP=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --skip-wakatime    Skip WakaTime configuration"
            echo "  --backup          Create backup of existing configs"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Fonctions utilitaires
print_message() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Fonction pour créer un backup
backup_if_exists() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
        if [[ "$CREATE_BACKUP" == true ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$file" "$BACKUP_DIR/"
            print_info "Backup créé: $BACKUP_DIR/$(basename "$file")"
        fi
    fi
}

# Fonction pour installer un paquet
install_package() {
    if ! command -v $1 &> /dev/null; then
        print_message "Installation de $1..."
        sudo apt-get install -y $1
    else
        print_info "$1 est déjà installé."
    fi
}

# Fonction pour créer un lien symbolique sécurisé
safe_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -f "$source" ]] && [[ ! -d "$source" ]]; then
        print_error "Source n'existe pas: $source"
        return 1
    fi
    
    backup_if_exists "$target"
    
    # Supprimer le lien/fichier existant
    rm -rf "$target"
    
    # Créer le lien symbolique
    ln -sf "$source" "$target"
    print_message "Lien créé: $(basename "$target")"
}

# Fonction pour installer les scripts personnels
install_scripts() {
    print_message "Installation des scripts personnels..."
    
    # Créer le répertoire bin personnel s'il n'existe pas
    if [[ ! -d "$HOME/.local/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
        print_info "Répertoire ~/.local/bin créé"
    fi
    
    # Copier et rendre exécutables les scripts
    if [[ -d "$DOTFILES_DIR/scripts" ]]; then
        for script in "$DOTFILES_DIR/scripts"/*.sh; do
            if [[ -f "$script" ]]; then
                script_name=$(basename "$script" .sh)
                cp "$script" "$HOME/.local/bin/$script_name"
                chmod +x "$HOME/.local/bin/$script_name"
                print_message "Script installé: $script_name"
            fi
        done
    fi
    
    # Copier les binaires
    if [[ -d "$DOTFILES_DIR/binaries" ]]; then
        for binary in "$DOTFILES_DIR/binaries"/*.sh; do
            if [[ -f "$binary" ]]; then
                binary_name=$(basename "$binary" .sh)
                cp "$binary" "$HOME/.local/bin/$binary_name"
                chmod +x "$HOME/.local/bin/$binary_name"
                print_message "Binaire installé: $binary_name"
            fi
        done
    fi
    
    # Vérifier que ~/.local/bin est dans le PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "$HOME/.local/bin n'est pas dans le PATH"
        print_info "Ajout à ~/.zshrc..."
        echo '' >> "$HOME/.zshrc"
        echo '# Scripts personnels' >> "$HOME/.zshrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    
    print_success "Scripts installés dans ~/.local/bin"
}

# Fonction pour rendre les scripts exécutables
make_scripts_executable() {
    print_message "Configuration des permissions..."
    
    # Rendre exécutables tous les scripts dans dotfiles
    find "$DOTFILES_DIR" -name "*.sh" -type f -exec chmod +x {} \;
    
    # Scripts principaux
    chmod +x "$DOTFILES_DIR/install.sh" 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/check-syntax.sh" 2>/dev/null || true
    
    print_success "Permissions configurées"
}

# Fonction pour configurer WakaTime
setup_wakatime() {
    if [[ "$SKIP_WAKATIME" == true ]]; then
        print_info "Configuration WakaTime ignorée (--skip-wakatime)"
        return 0
    fi
    
    local wakatime_config="$HOME/.wakatime.cfg"
    local wakatime_template="$DOTFILES_DIR/.wakatime.cfg.template"
    
    if [[ ! -f "$wakatime_template" ]]; then
        print_error "Template WakaTime introuvable: $wakatime_template"
        return 1
    fi
    
    # Vérifier si WakaTime est déjà configuré
    if [[ -f "$wakatime_config" ]] && grep -q "api_key=waka_" "$wakatime_config"; then
        print_info "WakaTime déjà configuré avec une API key valide"
        read -p "Voulez-vous reconfigurer WakaTime? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    print_info "Configuration de WakaTime..."
    echo "Pour obtenir votre API key WakaTime:"
    echo "1. Allez sur https://wakatime.com/api-key"
    echo "2. Copiez votre API key"
    echo
    
    read -p "Entrez votre API key WakaTime (ou appuyez sur Entrée pour ignorer): " api_key
    
    if [[ -z "$api_key" ]]; then
        print_warning "Configuration WakaTime ignorée"
        return 0
    fi
    
    # Valider le format de l'API key
    if [[ ! "$api_key" =~ ^waka_[a-f0-9-]+$ ]]; then
        print_error "Format d'API key invalide. Elle doit commencer par 'waka_'"
        return 1
    fi
    
    # Créer le fichier de config
    backup_if_exists "$wakatime_config"
    sed "s/YOUR_WAKATIME_API_KEY_HERE/$api_key/" "$wakatime_template" > "$wakatime_config"
    print_message "WakaTime configuré avec succès"
}

# Fonction principale d'installation
main() {
    print_info "🚀 Installation des dotfiles de thesyd"
    print_info "Répertoire: $DOTFILES_DIR"
    
    if [[ "$CREATE_BACKUP" == true ]]; then
        print_info "Les backups seront créés dans: $BACKUP_DIR"
    fi
    
    # Mettre à jour les paquets
    print_message "Mise à jour des paquets..."
    sudo apt-get update && sudo apt-get upgrade -y
    
    # Installer les logiciels nécessaires
    print_message "Installation des paquets essentiels..."
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
        print_info "Go est déjà installé."
    fi
    
    # Installer Rust et Cargo
    if ! command -v cargo &> /dev/null; then
        print_message "Installation de Rust et Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
    else
        print_info "Rust et Cargo sont déjà installés."
    fi
    
    # Installer Node.js
    if ! command -v node &> /dev/null; then
        print_message "Installation de Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        print_info "Node.js est déjà installé."
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
        print_info "Neovim est déjà installé."
    fi
    
    # Installer Oh My Zsh si ce n'est pas déjà fait
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_message "Installation de Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_info "Oh My Zsh est déjà installé."
    fi
    
    # Créer les liens symboliques
    print_message "Création des liens symboliques..."
    safe_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    safe_symlink "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
    safe_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    safe_symlink "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
    safe_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    safe_symlink "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    
    # Copier le fichier d'alias
    if [[ -f "$DOTFILES_DIR/aliases.zsh" ]]; then
        mkdir -p "$HOME/.config/dotfiles"
        cp "$DOTFILES_DIR/aliases.zsh" "$HOME/.config/dotfiles/aliases.zsh"
        print_message "Fichier d'alias installé"
    fi
    
    # Configurer WakaTime
    setup_wakatime
    
    # Installer les scripts personnels
    install_scripts
    
    # Rendre tous les scripts exécutables
    make_scripts_executable
    
    # Copier les dossiers
    print_message "Configuration des dossiers..."
    if [ -d "$DOTFILES_DIR/.config" ]; then
        backup_if_exists "$HOME/.config"
        cp -r "$DOTFILES_DIR/.config" "$HOME/"
        print_message "Dossier .config copié"
    else
        print_warning "Le dossier .config n'existe pas dans dotfiles"
    fi
    
    # Copier Oh My Zsh personnalisé
    print_message "Configuration Oh My Zsh personnalisée..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        [[ -d "$DOTFILES_DIR/custom" ]] && cp -r "$DOTFILES_DIR/custom"/* "$HOME/.oh-my-zsh/custom/"
        [[ -d "$DOTFILES_DIR/themes" ]] && cp -r "$DOTFILES_DIR/themes"/* "$HOME/.oh-my-zsh/themes/"
        [[ -d "$DOTFILES_DIR/plugins" ]] && cp -r "$DOTFILES_DIR/plugins"/* "$HOME/.oh-my-zsh/plugins/"
        print_message "Configuration Oh My Zsh mise à jour"
    else
        print_error "Oh My Zsh n'est pas installé"
    fi
    
    # Changer le shell par défaut pour Zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_message "Changement du shell par défaut pour Zsh..."
        chsh -s $(which zsh)
        print_warning "Redémarrez votre session pour appliquer le changement de shell"
    fi
    
    print_message "🎉 Installation terminée avec succès!"
    print_info "Redémarrez votre terminal ou exécutez 'source ~/.zshrc'"
    
    if [[ "$CREATE_BACKUP" == true ]] && [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backups sauvegardés dans: $BACKUP_DIR"
    fi
}

# Exécuter le script principal
main "$@"
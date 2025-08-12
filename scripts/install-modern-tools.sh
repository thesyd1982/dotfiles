#!/bin/bash

# Modern CLI Tools Installer - Installation d'outils CLI modernes
# Usage: ./install-modern-tools.sh [--all] [tool1] [tool2] ...

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# Vérifier si on est sur Ubuntu/Debian
check_system() {
    if ! command -v apt &> /dev/null; then
        print_error "Ce script nécessite apt (Ubuntu/Debian)"
        exit 1
    fi
}

# Installer exa (ls amélioré)
install_exa() {
    if command -v exa &> /dev/null; then
        print_info "exa est déjà installé"
        return 0
    fi
    
    print_info "Installation d'exa..."
    if curl -sL https://api.github.com/repos/ogham/exa/releases/latest | \
       jq -r '.assets[] | select(.name | contains("linux-x86_64")) | .browser_download_url' | \
       xargs curl -sL | tar xz -C /tmp; then
        sudo mv /tmp/bin/exa /usr/local/bin/
        print_success "exa installé"
    else
        print_warning "Installation via cargo..."
        cargo install exa 2>/dev/null || {
            print_error "Échec installation exa"
            return 1
        }
    fi
}

# Installer ripgrep (grep amélioré)
install_ripgrep() {
    if command -v rg &> /dev/null; then
        print_info "ripgrep est déjà installé"
        return 0
    fi
    
    print_info "Installation de ripgrep..."
    sudo apt update && sudo apt install -y ripgrep
    print_success "ripgrep installé"
}

# Installer fd (find amélioré)
install_fd() {
    if command -v fd &> /dev/null; then
        print_info "fd est déjà installé"
        return 0
    fi
    
    print_info "Installation de fd..."
    sudo apt update && sudo apt install -y fd-find
    
    # Créer un alias si nécessaire
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
    fi
    
    print_success "fd installé"
}

# Installer bat (cat amélioré) - améliorer l'installation existante
install_bat() {
    if command -v bat &> /dev/null; then
        print_info "bat est déjà installé"
        return 0
    fi
    
    if command -v batcat &> /dev/null; then
        print_info "batcat détecté, création d'un alias bat..."
        sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
        print_success "Alias bat créé"
        return 0
    fi
    
    print_info "Installation de bat..."
    sudo apt update && sudo apt install -y bat
    print_success "bat installé"
}

# Installer delta (git diff amélioré)
install_delta() {
    if command -v delta &> /dev/null; then
        print_info "delta est déjà installé"
        return 0
    fi
    
    print_info "Installation de delta..."
    
    # Télécharger la dernière version
    local delta_url
    delta_url=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | \
                jq -r '.assets[] | select(.name | contains("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url')
    
    if [[ -n "$delta_url" ]]; then
        curl -sL "$delta_url" | tar xz -C /tmp
        sudo mv /tmp/delta-*/delta /usr/local/bin/
        print_success "delta installé"
        
        # Configurer git pour utiliser delta
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global merge.conflictstyle diff3
        git config --global diff.colorMoved default
        print_info "Git configuré pour utiliser delta"
    else
        print_error "Échec du téléchargement de delta"
        return 1
    fi
}

# Installer lazygit (interface git)
install_lazygit() {
    if command -v lazygit &> /dev/null; then
        print_info "lazygit est déjà installé"
        return 0
    fi
    
    print_info "Installation de lazygit..."
    
    local lazygit_url
    lazygit_url=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | \
                  jq -r '.assets[] | select(.name | contains("Linux_x86_64.tar.gz")) | .browser_download_url')
    
    if [[ -n "$lazygit_url" ]]; then
        curl -sL "$lazygit_url" | tar xz -C /tmp
        sudo mv /tmp/lazygit /usr/local/bin/
        print_success "lazygit installé"
    else
        print_error "Échec du téléchargement de lazygit"
        return 1
    fi
}

# Installer fzf (fuzzy finder)
install_fzf() {
    if command -v fzf &> /dev/null; then
        print_info "fzf est déjà installé"
        return 0
    fi
    
    print_info "Installation de fzf..."
    
    # Installation via git
    if [[ ! -d "$HOME/.fzf" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all
        print_success "fzf installé"
    else
        print_info "fzf déjà présent dans ~/.fzf"
    fi
}

# Installer htop (top amélioré)
install_htop() {
    if command -v htop &> /dev/null; then
        print_info "htop est déjà installé"
        return 0
    fi
    
    print_info "Installation de htop..."
    sudo apt update && sudo apt install -y htop
    print_success "htop installé"
}

# Installer tree (affichage arborescence)
install_tree() {
    if command -v tree &> /dev/null; then
        print_info "tree est déjà installé"
        return 0
    fi
    
    print_info "Installation de tree..."
    sudo apt update && sudo apt install -y tree
    print_success "tree installé"
}

# Fonction d'aide
show_help() {
    echo "Modern CLI Tools Installer"
    echo ""
    echo "Usage: $0 [OPTIONS] [TOOLS]"
    echo ""
    echo "Options:"
    echo "  --all       Installer tous les outils"
    echo "  --help      Afficher cette aide"
    echo ""
    echo "Outils disponibles:"
    echo "  exa         ls amélioré avec couleurs et icônes"
    echo "  ripgrep     grep ultra-rapide (rg)"
    echo "  fd          find moderne et rapide"
    echo "  bat         cat avec coloration syntaxique"
    echo "  delta       git diff magnifique"
    echo "  lazygit     interface git dans le terminal"
    echo "  fzf         fuzzy finder interactif"
    echo "  htop        top amélioré"
    echo "  tree        affichage arborescence"
    echo ""
    echo "Exemples:"
    echo "  $0 --all                    # Installer tous les outils"
    echo "  $0 exa ripgrep fd          # Installer outils spécifiques"
    echo "  $0 lazygit delta           # Installer outils git"
}

# Mettre à jour les alias après installation
update_aliases() {
    local aliases_file="$HOME/.config/dotfiles/aliases.zsh"
    
    if [[ -f "$aliases_file" ]]; then
        print_info "Mise à jour des alias..."
        
        # Sauvegarder l'original
        cp "$aliases_file" "$aliases_file.bak"
        
        # Ajouter les nouveaux alias si les outils sont installés
        {
            echo ""
            echo "# ========================================"
            echo "# 🛠 OUTILS CLI MODERNES (auto-générés)"
            echo "# ========================================"
            
            if command -v exa &> /dev/null; then
                echo "alias ls='exa'"
                echo "alias ll='exa -la --icons'"
                echo "alias la='exa -a --icons'"
                echo "alias tree='exa --tree'"
            fi
            
            if command -v rg &> /dev/null; then
                echo "alias grep='rg'"
            fi
            
            if command -v fd &> /dev/null; then
                echo "alias find='fd'"
            fi
            
            if command -v bat &> /dev/null; then
                echo "alias cat='bat'"
            fi
            
            if command -v lazygit &> /dev/null; then
                echo "alias lg='lazygit'"
            fi
            
            if command -v htop &> /dev/null; then
                echo "alias top='htop'"
            fi
            
        } >> "$aliases_file"
        
        print_success "Alias mis à jour dans $aliases_file"
        print_info "Rechargez votre shell avec: source ~/.zshrc"
    fi
}

# Installation de tous les outils
install_all() {
    print_info "🚀 Installation de tous les outils CLI modernes..."
    
    local tools=(
        "exa" "ripgrep" "fd" "bat" "delta" 
        "lazygit" "fzf" "htop" "tree"
    )
    
    for tool in "${tools[@]}"; do
        "install_$tool"
    done
    
    update_aliases
    print_success "🎉 Tous les outils installés!"
}

# Main
main() {
    check_system
    
    case "$1" in
        "--all")
            install_all
            ;;
        "--help"|"-h"|"")
            show_help
            ;;
        *)
            # Installer les outils spécifiés
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    "exa"|"ripgrep"|"fd"|"bat"|"delta"|"lazygit"|"fzf"|"htop"|"tree")
                        "install_$1"
                        ;;
                    *)
                        print_error "Outil inconnu: $1"
                        ;;
                esac
                shift
            done
            
            update_aliases
            ;;
    esac
}

main "$@"
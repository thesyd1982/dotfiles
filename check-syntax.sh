#!/bin/bash

# Dotfiles Syntax Checker - Vérificateur de syntaxe des dotfiles
# Usage: ./check-syntax.sh

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0

print_info "🔍 Vérification de la syntaxe des dotfiles..."
echo ""

# Vérifier la syntaxe des scripts bash
check_bash_syntax() {
    local file="$1"
    local filename=$(basename "$file")
    
    if bash -n "$file" 2>/dev/null; then
        print_success "$filename - Syntaxe bash correcte"
    else
        print_error "$filename - Erreur de syntaxe bash"
        echo "Détails de l'erreur :"
        bash -n "$file"
        echo ""
        ((ERRORS++))
    fi
}

# Vérifier la syntaxe zsh
check_zsh_syntax() {
    local file="$1"
    local filename=$(basename "$file")
    
    if command -v zsh &> /dev/null; then
        if zsh -n "$file" 2>/dev/null; then
            print_success "$filename - Syntaxe zsh correcte"
        else
            print_error "$filename - Erreur de syntaxe zsh"
            echo "Détails de l'erreur :"
            zsh -n "$file"
            echo ""
            ((ERRORS++))
        fi
    else
        print_warning "$filename - zsh non disponible, vérification ignorée"
    fi
}

# Vérifier la syntaxe JSON
check_json_syntax() {
    local file="$1"
    local filename=$(basename "$file")
    
    if command -v jq &> /dev/null; then
        if jq empty "$file" 2>/dev/null; then
            print_success "$filename - JSON valide"
        else
            print_error "$filename - JSON invalide"
            echo "Détails de l'erreur :"
            jq empty "$file"
            echo ""
            ((ERRORS++))
        fi
    else
        print_warning "$filename - jq non disponible, vérification JSON ignorée"
    fi
}

# Vérifier l'intégrité des fichiers
check_file_integrity() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Vérifier que le fichier n'est pas tronqué
    if [[ -f "$file" ]]; then
        local last_line=$(tail -1 "$file")
        local file_size=$(wc -c < "$file")
        
        if [[ $file_size -eq 0 ]]; then
            print_error "$filename - Fichier vide"
            ((ERRORS++))
        elif [[ -z "$last_line" ]] && [[ "$filename" != *.md ]]; then
            print_warning "$filename - Se termine par une ligne vide"
        else
            print_success "$filename - Intégrité OK"
        fi
    else
        print_error "$filename - Fichier introuvable"
        ((ERRORS++))
    fi
}

echo "📋 Vérification des scripts bash..."
echo "================================="

# Scripts dans /scripts
if [[ -d "$DOTFILES_DIR/scripts" ]]; then
    for script in "$DOTFILES_DIR/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            check_bash_syntax "$script"
            check_file_integrity "$script"
        fi
    done
fi

# Scripts dans /binaries  
if [[ -d "$DOTFILES_DIR/binaries" ]]; then
    for script in "$DOTFILES_DIR/binaries"/*.sh; do
        if [[ -f "$script" ]]; then
            check_bash_syntax "$script"
            check_file_integrity "$script"
        fi
    done
fi

# Script d'installation principal
if [[ -f "$DOTFILES_DIR/install.sh" ]]; then
    check_bash_syntax "$DOTFILES_DIR/install.sh"
    check_file_integrity "$DOTFILES_DIR/install.sh"
fi

echo ""
echo "📋 Vérification des fichiers de configuration..."
echo "=============================================="

# Fichiers de config shell
if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
    check_zsh_syntax "$DOTFILES_DIR/.zshrc"
    check_file_integrity "$DOTFILES_DIR/.zshrc"
fi

if [[ -f "$DOTFILES_DIR/aliases.zsh" ]]; then
    check_zsh_syntax "$DOTFILES_DIR/aliases.zsh"
    check_file_integrity "$DOTFILES_DIR/aliases.zsh"
fi

if [[ -f "$DOTFILES_DIR/.zshenv" ]]; then
    check_zsh_syntax "$DOTFILES_DIR/.zshenv"
    check_file_integrity "$DOTFILES_DIR/.zshenv"
fi

echo ""
echo "📋 Vérification des fichiers JSON/config..."
echo "========================================="

# Fichiers JSON
for json_file in "$DOTFILES_DIR"/*.json "$DOTFILES_DIR/.config"/**/*.json; do
    if [[ -f "$json_file" ]]; then
        check_json_syntax "$json_file"
        check_file_integrity "$json_file"
    fi
done

echo ""
echo "📋 Vérification des permissions..."
echo "================================"

# Vérifier que les scripts sont exécutables
for script in "$DOTFILES_DIR/scripts"/*.sh "$DOTFILES_DIR/binaries"/*.sh "$DOTFILES_DIR/install.sh"; do
    if [[ -f "$script" ]]; then
        local filename=$(basename "$script")
        if [[ -x "$script" ]]; then
            print_success "$filename - Exécutable"
        else
            print_warning "$filename - Non exécutable"
            echo "  Corrigez avec: chmod +x $script"
        fi
    fi
done

echo ""
echo "📋 Vérification des dépendances..."
echo "================================"

# Vérifier les commandes utilisées dans les scripts
declare -A commands_needed
commands_needed=(
    ["tmux"]="session-manager.sh, project-switch.sh"
    ["zoxide"]="project-switch.sh, aliases.zsh"
    ["git"]="git-quick.sh, install.sh"
    ["jq"]="dev-server.sh, project-switch.sh"
    ["curl"]="install-modern-tools.sh, aliases.zsh"
)

for cmd in "${!commands_needed[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        print_success "$cmd - Disponible"
    else
        print_warning "$cmd - Manquant (utilisé dans: ${commands_needed[$cmd]})"
    fi
done

echo ""
echo "📊 Résumé de la vérification"
echo "============================"

if [[ $ERRORS -eq 0 ]]; then
    print_success "🎉 Tous les fichiers sont corrects!"
    print_info "Vos dotfiles sont prêts à être utilisés"
else
    print_error "⚠️ $ERRORS erreur(s) détectée(s)"
    print_info "Corrigez les erreurs avant d'utiliser les dotfiles"
    exit 1
fi

echo ""
print_info "💡 Pour tester l'installation complète:"
echo "  ./install.sh --backup"
echo ""
print_info "💡 Pour tester un script spécifique:"
echo "  ./scripts/session-manager.sh --help"
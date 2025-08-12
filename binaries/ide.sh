#!/bin/bash

# IDE Setup Script - Crée un environnement de développement avec tmux
# Usage: ide.sh [directory] [session_name]
# Exemples:
#   ide.sh                        # Session dans le répertoire courant
#   ide.sh ~/projects/mon-app    # Session dans un répertoire spécifique  
#   ide.sh ~/projects/mon-app myapp # Session avec nom personnalisé

# Configuration par défaut
DEFAULT_SESSION="ide"
LAYOUT_CONFIG="main-vertical"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Fonction pour vérifier si tmux est installé
check_tmux() {
    if ! command -v tmux &> /dev/null; then
        print_error "tmux n'est pas installé"
        print_info "Installation: sudo apt install tmux"
        exit 1
    fi
}

# Fonction pour vérifier si une session tmux existe
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Fonction pour créer la session tmux IDE
create_tmux_session() {
    local session_name="$1"
    local work_dir="$2"
    
    print_info "Création de la session tmux: $session_name"
    print_info "Répertoire de travail: $work_dir"
    
    # Changer vers le répertoire de travail
    if [[ -n "$work_dir" ]] && [[ -d "$work_dir" ]]; then
        cd "$work_dir" || {
            print_error "Impossible d'accéder au répertoire: $work_dir"
            exit 1
        }
    fi
    
    # Vérifier si la session existe déjà
    if session_exists "$session_name"; then
        print_warning "La session '$session_name' existe déjà"
        read -p "Voulez-vous vous y attacher? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            tmux attach -t "$session_name"
            exit 0
        else
            print_error "Opération annulée"
            exit 1
        fi
    fi
    
    # Créer une nouvelle session tmux en mode détaché
    tmux new-session -d -s "$session_name" -c "$PWD"
    
    # Renommer la première fenêtre
    local window_name=$(basename "$PWD")
    tmux rename-window -t "$session_name:0" "$window_name"
    
    # Layout: 4 panneaux
    # ┌─────────────┬─────────┐
    # │             │         │
    # │   EDITOR    │  TERM1  │
    # │   (nvim)    │         │
    # │             ├─────────┤
    # │             │         │
    # │             │  TERM2  │
    # └─────────────┴─────────┘
    
    # Diviser verticalement (éditeur à gauche, terminaux à droite)
    tmux split-window -h -p 40 -t "$session_name:0"
    
    # Diviser le panneau de droite horizontalement
    tmux split-window -v -p 50 -t "$session_name:0.1"
    
    # Optionnel: Ajouter un 4ème panneau en bas
    tmux split-window -v -p 30 -t "$session_name:0.0"
    
    # Configuration des panneaux
    # Panneau 0 (éditeur principal)
    tmux send-keys -t "$session_name:0.0" 'nvim .' C-m
    
    # Panneau 1 (terminal de développement) 
    tmux send-keys -t "$session_name:0.1" 'echo "🚀 Terminal de développement prêt"' C-m
    
    # Panneau 2 (terminal git/utils)
    tmux send-keys -t "$session_name:0.2" 'echo "📁 $(pwd)"' C-m
    tmux send-keys -t "$session_name:0.2" 'git status 2>/dev/null || echo "📂 Répertoire non-git"' C-m
    
    # Panneau 3 (logs/monitoring)
    tmux send-keys -t "$session_name:0.3" 'echo "📊 Logs & monitoring"' C-m
    
    # Revenir au panneau de l'éditeur
    tmux select-pane -t "$session_name:0.0"
    
    print_success "Session IDE créée avec succès!"
    print_info "Layout: Éditeur + 3 terminaux"
    print_info "Raccourcis tmux utiles:"
    echo "  Ctrl+b + o        : Changer de panneau"
    echo "  Ctrl+b + z        : Zoom sur le panneau actuel"
    echo "  Ctrl+b + \"       : Diviser horizontalement"
    echo "  Ctrl+b + %        : Diviser verticalement"
    echo "  Ctrl+b + d        : Détacher la session"
    echo "  tmux attach -t $session_name : Se rattacher"
    
    # Attacher la session
    tmux attach -t "$session_name"
}

# Fonction d'aide
show_help() {
    echo "IDE Setup Script - Environnement de développement tmux"
    echo ""
    echo "Usage: $0 [directory] [session_name]"
    echo ""
    echo "Arguments:"
    echo "  directory     Répertoire de travail (optionnel)"
    echo "  session_name  Nom de la session tmux (optionnel)"
    echo ""
    echo "Exemples:"
    echo "  $0                          # Session dans le répertoire courant"
    echo "  $0 ~/projects/mon-app      # Session dans un répertoire spécifique"
    echo "  $0 ~/projects/mon-app dev  # Session avec nom personnalisé"
    echo ""
    echo "Options:"
    echo "  -h, --help    Afficher cette aide"
    echo ""
    echo "La session créée contient:"
    echo "  • 1 panneau éditeur (Neovim)"
    echo "  • 3 panneaux terminaux (dev, git, logs)"
}

# Parser les arguments
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
esac

# Vérifications préliminaires
check_tmux

# Déterminer les paramètres
if [[ $# -eq 0 ]]; then
    # Aucun argument: utiliser le répertoire courant
    work_dir="$PWD"
    session_name="$DEFAULT_SESSION"
elif [[ $# -eq 1 ]]; then
    # Un argument: répertoire de travail
    work_dir="$1"
    session_name="$DEFAULT_SESSION"
elif [[ $# -eq 2 ]]; then
    # Deux arguments: répertoire + nom de session
    work_dir="$1"
    session_name="$2"
else
    print_error "Trop d'arguments"
    show_help
    exit 1
fi

# Créer la session
create_tmux_session "$session_name" "$work_dir"
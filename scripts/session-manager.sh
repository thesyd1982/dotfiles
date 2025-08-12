#!/bin/bash

# Session Manager - Gestionnaire de sessions tmux intelligent
# Usage: session-manager [command] [args]

SCRIPT_NAME=$(basename "$0")

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_header() { echo -e "${CYAN}$1${NC}"; }

# Vérifier si tmux est disponible
check_tmux() {
    if ! command -v tmux &> /dev/null; then
        print_error "tmux n'est pas installé"
        exit 1
    fi
}

# Lister toutes les sessions tmux
list_sessions() {
    print_header "📋 Sessions tmux actives:"
    echo ""
    
    if ! tmux list-sessions 2>/dev/null; then
        print_warning "Aucune session tmux active"
        return 1
    fi
    
    echo ""
    print_info "💡 Utilisez: $SCRIPT_NAME attach <nom> pour vous connecter"
}

# Attacher à une session ou la créer si elle n'existe pas
attach_session() {
    local session_name="$1"
    
    if [[ -z "$session_name" ]]; then
        print_error "Nom de session requis"
        echo "Usage: $SCRIPT_NAME attach <nom-session>"
        return 1
    fi
    
    # Vérifier si la session existe
    if tmux has-session -t "$session_name" 2>/dev/null; then
        print_info "Connexion à la session existante: $session_name"
        tmux attach -t "$session_name"
    else
        print_info "Création et connexion à une nouvelle session: $session_name"
        tmux new-session -s "$session_name"
    fi
}

# Créer une session de développement dans un projet
dev_session() {
    local project_path="$1"
    local session_name="$2"
    
    # Si pas de chemin donné, utiliser le répertoire courant
    if [[ -z "$project_path" ]]; then
        project_path="$(pwd)"
    fi
    
    # Si pas de nom donné, utiliser le nom du dossier
    if [[ -z "$session_name" ]]; then
        session_name=$(basename "$project_path")
    fi
    
    print_info "Création session de dev: $session_name"
    print_info "Projet: $project_path"
    
    # Aller dans le dossier du projet
    if [[ ! -d "$project_path" ]]; then
        print_error "Dossier inexistant: $project_path"
        return 1
    fi
    
    cd "$project_path" || return 1
    
    # Vérifier si la session existe déjà
    if tmux has-session -t "$session_name" 2>/dev/null; then
        print_warning "Session '$session_name' existe déjà"
        read -p "Voulez-vous vous y connecter? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            tmux attach -t "$session_name"
            return 0
        else
            return 1
        fi
    fi
    
    # Créer la session de développement
    tmux new-session -d -s "$session_name" -c "$project_path"
    
    # Layout de développement
    # Fenêtre 1: Éditeur + Terminal
    tmux rename-window -t "$session_name:0" "dev"
    tmux split-window -h -p 30 -t "$session_name:0"
    tmux split-window -v -p 50 -t "$session_name:0.1"
    
    # Fenêtre 2: Serveur/Logs
    tmux new-window -t "$session_name" -n "server"
    
    # Fenêtre 3: Git/Tests
    tmux new-window -t "$session_name" -n "git"
    
    # Commandes dans les panneaux
    # Dev - Éditeur
    tmux send-keys -t "$session_name:dev.0" 'nvim .' C-m
    
    # Dev - Terminal projet
    tmux send-keys -t "$session_name:dev.1" "echo '🚀 Projet: $session_name'" C-m
    tmux send-keys -t "$session_name:dev.1" "echo '📁 $(pwd)'" C-m
    
    # Dev - Git status
    tmux send-keys -t "$session_name:dev.2" 'git status 2>/dev/null || echo "📂 Projet non-git"' C-m
    
    # Server - Détecter et lancer le serveur
    detect_and_start_server "$session_name"
    
    # Git - Préparer les commandes git courantes
    tmux send-keys -t "$session_name:git" "echo '📋 Commandes Git rapides:'" C-m
    tmux send-keys -t "$session_name:git" "echo '  git status'" C-m
    tmux send-keys -t "$session_name:git" "echo '  git add .'" C-m
    tmux send-keys -t "$session_name:git" "echo '  git commit -m \"message\"'" C-m
    
    # Retourner à la fenêtre dev
    tmux select-window -t "$session_name:dev"
    tmux select-pane -t "$session_name:dev.0"
    
    print_success "Session de dev '$session_name' créée!"
    print_info "Layout: Éditeur + Terminal + Git/Server"
    
    # Se connecter à la session
    tmux attach -t "$session_name"
}

# Détecter le type de projet et lancer le serveur approprié
detect_and_start_server() {
    local session_name="$1"
    
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts.dev' package.json >/dev/null 2>&1; then
            tmux send-keys -t "$session_name:server" "npm run dev" C-m
        elif jq -e '.scripts.start' package.json >/dev/null 2>&1; then
            tmux send-keys -t "$session_name:server" "npm start" C-m
        else
            tmux send-keys -t "$session_name:server" "echo '📦 Projet Node.js détecté'" C-m
        fi
    elif [[ -f "Cargo.toml" ]]; then
        tmux send-keys -t "$session_name:server" "cargo run" C-m
    elif [[ -f "go.mod" ]]; then
        if command -v air &> /dev/null; then
            tmux send-keys -t "$session_name:server" "air" C-m
        else
            tmux send-keys -t "$session_name:server" "go run ." C-m
        fi
    elif [[ -f "manage.py" ]]; then
        tmux send-keys -t "$session_name:server" "python manage.py runserver" C-m
    else
        tmux send-keys -t "$session_name:server" "echo '💡 Lancez votre serveur ici'" C-m
    fi
}

# Tuer une session
kill_session() {
    local session_name="$1"
    
    if [[ -z "$session_name" ]]; then
        print_error "Nom de session requis"
        echo "Usage: $SCRIPT_NAME kill <nom-session>"
        return 1
    fi
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux kill-session -t "$session_name"
        print_success "Session '$session_name' supprimée"
    else
        print_warning "Session '$session_name' n'existe pas"
    fi
}

# Nettoyer toutes les sessions
cleanup_sessions() {
    print_warning "⚠️ Cela va fermer TOUTES les sessions tmux"
    read -p "Êtes-vous sûr? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tmux kill-server 2>/dev/null || true
        print_success "Toutes les sessions supprimées"
    else
        print_info "Opération annulée"
    fi
}

# Navigation rapide avec zoxide
quick_dev() {
    if ! command -v zoxide &> /dev/null; then
        print_error "zoxide n'est pas installé"
        print_info "Installation: curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
        return 1
    fi
    
    local query="$1"
    
    if [[ -z "$query" ]]; then
        print_info "Projets récents (zoxide):"
        zoxide query -l | head -10
        echo ""
        print_info "Usage: $SCRIPT_NAME quick <projet>"
        return 0
    fi
    
    # Trouver le projet avec zoxide
    local project_path
    project_path=$(zoxide query "$query" 2>/dev/null)
    
    if [[ -z "$project_path" ]]; then
        print_error "Projet '$query' non trouvé dans zoxide"
        print_info "Projets disponibles:"
        zoxide query -l | grep -i "$query" | head -5
        return 1
    fi
    
    # Créer une session de dev dans ce projet
    dev_session "$project_path"
}

# Fonction d'aide
show_help() {
    echo "Session Manager - Gestionnaire de sessions tmux intelligent"
    echo ""
    echo "Usage: $SCRIPT_NAME <command> [args]"
    echo ""
    echo "Commandes:"
    echo "  list                    Lister toutes les sessions"
    echo "  attach <nom>           Se connecter à une session (la crée si nécessaire)"
    echo "  dev [dossier] [nom]    Créer session de développement"
    echo "  quick <projet>         Session de dev rapide avec zoxide"
    echo "  kill <nom>             Supprimer une session"
    echo "  cleanup                Supprimer toutes les sessions"
    echo "  help                   Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $SCRIPT_NAME list"
    echo "  $SCRIPT_NAME attach work"
    echo "  $SCRIPT_NAME dev ~/projects/mon-app"
    echo "  $SCRIPT_NAME quick mon-app"
    echo "  $SCRIPT_NAME kill old-session"
    echo ""
    echo "La commande 'dev' crée automatiquement:"
    echo "  • Fenêtre 'dev': Éditeur + Terminaux"
    echo "  • Fenêtre 'server': Serveur de développement"
    echo "  • Fenêtre 'git': Commandes Git"
}

# Parser les commandes
check_tmux

case "$1" in
    "list"|"ls")
        list_sessions
        ;;
    "attach"|"a")
        attach_session "$2"
        ;;
    "dev"|"d")
        dev_session "$2" "$3"
        ;;
    "quick"|"q")
        quick_dev "$2"
        ;;
    "kill"|"k")
        kill_session "$2"
        ;;
    "cleanup"|"clean")
        cleanup_sessions
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        print_error "Commande inconnue: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
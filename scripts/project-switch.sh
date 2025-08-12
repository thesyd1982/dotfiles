#!/bin/bash

# Project Switch - Bascule rapide entre projets avec zoxide + tmux
# Usage: project-switch [query]

SCRIPT_NAME=$(basename "$0")

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_header() { echo -e "${CYAN}$1${NC}"; }
print_project() { echo -e "${MAGENTA}$1${NC}"; }

# Vérifier les dépendances
check_dependencies() {
    local missing=()
    
    if ! command -v zoxide &> /dev/null; then
        missing+=("zoxide")
    fi
    
    if ! command -v tmux &> /dev/null; then
        missing+=("tmux")
    fi
    
    if ! command -v fzf &> /dev/null; then
        print_warning "fzf non installé - utilisation du mode simple"
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Outils manquants: ${missing[*]}"
        echo ""
        echo "Installation:"
        for tool in "${missing[@]}"; do
            case $tool in
                "zoxide")
                    echo "  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
                    ;;
                "tmux")
                    echo "  sudo apt install tmux"
                    ;;
            esac
        done
        exit 1
    fi
}

# Sélectionner un projet avec fzf ou menu simple
select_project() {
    local query="$1"
    local projects
    
    # Obtenir la liste des projets zoxide
    if ! projects=$(zoxide query -l 2>/dev/null); then
        print_error "Aucun projet dans zoxide"
        print_info "Naviguez dans vos projets avec 'z' pour les ajouter à zoxide"
        return 1
    fi
    
    # Si une requête est donnée, filtrer
    if [[ -n "$query" ]]; then
        projects=$(echo "$projects" | grep -i "$query")
        if [[ -z "$projects" ]]; then
            print_error "Aucun projet trouvé pour: $query"
            return 1
        fi
    fi
    
    # Utiliser fzf si disponible, sinon menu numéroté
    if command -v fzf &> /dev/null; then
        echo "$projects" | fzf --height=20 \
            --header="🚀 Sélectionnez un projet:" \
            --preview="ls -la {}" \
            --preview-window=right:50%
    else
        # Menu simple avec numéros
        local project_array=()
        while IFS= read -r line; do
            project_array+=("$line")
        done <<< "$projects"
        
        if [[ ${#project_array[@]} -eq 1 ]]; then
            echo "${project_array[0]}"
            return 0
        fi
        
        print_header "🚀 Sélectionnez un projet:"
        echo ""
        
        for i in "${!project_array[@]}"; do
            printf "%2d) %s\n" $((i+1)) "$(basename "${project_array[$i]}")"
        done
        
        echo ""
        read -p "Numéro (1-${#project_array[@]}): " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#project_array[@]} ]]; then
            echo "${project_array[$((choice-1))]}"
        else
            print_error "Choix invalide"
            return 1
        fi
    fi
}

# Obtenir les informations du projet
get_project_info() {
    local project_path="$1"
    local project_name
    local project_type="unknown"
    local git_status=""
    
    project_name=$(basename "$project_path")
    
    # Déterminer le type de projet
    if [[ -f "$project_path/package.json" ]]; then
        if [[ -f "$project_path/next.config.js" ]] || [[ -f "$project_path/next.config.ts" ]]; then
            project_type="Next.js"
        elif jq -e '.dependencies.react' "$project_path/package.json" >/dev/null 2>&1; then
            project_type="React"
        elif jq -e '.dependencies.vue' "$project_path/package.json" >/dev/null 2>&1; then
            project_type="Vue.js"
        elif jq -e '.dependencies.svelte' "$project_path/package.json" >/dev/null 2>&1; then
            project_type="Svelte"
        else
            project_type="Node.js"
        fi
    elif [[ -f "$project_path/Cargo.toml" ]]; then
        project_type="Rust"
    elif [[ -f "$project_path/go.mod" ]]; then
        project_type="Go"
    elif [[ -f "$project_path/requirements.txt" ]] || [[ -f "$project_path/pyproject.toml" ]]; then
        project_type="Python"
    elif [[ -f "$project_path/Gemfile" ]]; then
        project_type="Ruby"
    fi
    
    # Statut Git
    if [[ -d "$project_path/.git" ]]; then
        cd "$project_path" || return 1
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        local status
        status=$(git status --porcelain 2>/dev/null | wc -l)
        
        if [[ "$status" -gt 0 ]]; then
            git_status="$branch ($status changements)"
        else
            git_status="$branch (propre)"
        fi
    fi
    
    echo "name:$project_name"
    echo "type:$project_type"
    echo "git:$git_status"
    echo "path:$project_path"
}

# Basculer vers un projet
switch_to_project() {
    local project_path="$1"
    local session_name
    local project_info
    
    if [[ ! -d "$project_path" ]]; then
        print_error "Projet inexistant: $project_path"
        return 1
    fi
    
    # Obtenir les infos du projet
    project_info=$(get_project_info "$project_path")
    local project_name=$(echo "$project_info" | grep "^name:" | cut -d: -f2)
    local project_type=$(echo "$project_info" | grep "^type:" | cut -d: -f2)
    local git_status=$(echo "$project_info" | grep "^git:" | cut -d: -f2)
    
    session_name="$project_name"
    
    print_header "🚀 Basculement vers: $project_name"
    echo "📁 Chemin: $project_path"
    echo "🔧 Type: $project_type"
    if [[ -n "$git_status" ]]; then
        echo "🌿 Git: $git_status"
    fi
    echo ""
    
    # Vérifier si la session existe déjà
    if tmux has-session -t "$session_name" 2>/dev/null; then
        print_info "Session existante trouvée"
        
        # Si on est déjà dans tmux, basculer
        if [[ -n "$TMUX" ]]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach -t "$session_name"
        fi
    else
        print_info "Création d'une nouvelle session de développement..."
        
        # Utiliser le session-manager pour créer la session
        if command -v session-manager &> /dev/null; then
            session-manager dev "$project_path" "$session_name"
        else
            # Fallback: session simple
            cd "$project_path" || return 1
            tmux new-session -s "$session_name"
        fi
    fi
}

# Lister les projets avec leurs infos
list_projects() {
    local projects
    
    if ! projects=$(zoxide query -l 2>/dev/null); then
        print_error "Aucun projet dans zoxide"
        return 1
    fi
    
    print_header "📂 Projets disponibles:"
    echo ""
    
    while IFS= read -r project_path; do
        if [[ -d "$project_path" ]]; then
            local project_info
            project_info=$(get_project_info "$project_path")
            local project_name=$(echo "$project_info" | grep "^name:" | cut -d: -f2)
            local project_type=$(echo "$project_info" | grep "^type:" | cut -d: -f2)
            local git_status=$(echo "$project_info" | grep "^git:" | cut -d: -f2)
            
            printf "%-20s %-10s" "$project_name" "[$project_type]"
            if [[ -n "$git_status" ]]; then
                printf " 🌿 %s" "$git_status"
            fi
            echo ""
        fi
    done <<< "$projects"
    
    echo ""
    print_info "Usage: $SCRIPT_NAME [nom-projet]"
}

# Fonction d'aide
show_help() {
    echo "Project Switch - Bascule rapide entre projets"
    echo ""
    echo "Usage: $SCRIPT_NAME [query]"
    echo ""
    echo "Commandes:"
    echo "  $SCRIPT_NAME              Sélectionner un projet interactivement"
    echo "  $SCRIPT_NAME <query>      Rechercher et basculer vers un projet"
    echo "  $SCRIPT_NAME list         Lister tous les projets"
    echo "  $SCRIPT_NAME --help       Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $SCRIPT_NAME              # Sélection interactive"
    echo "  $SCRIPT_NAME mon-app      # Basculer vers 'mon-app'"
    echo "  $SCRIPT_NAME react        # Chercher projets contenant 'react'"
    echo ""
    echo "Le script utilise zoxide pour trouver vos projets récents"
    echo "et crée automatiquement des sessions tmux de développement."
}

# Fonction principale
main() {
    check_dependencies
    
    case "$1" in
        "list"|"ls")
            list_projects
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            # Sélection interactive
            local selected_project
            selected_project=$(select_project)
            if [[ -n "$selected_project" ]]; then
                switch_to_project "$selected_project"
            fi
            ;;
        *)
            # Recherche avec query
            local selected_project
            selected_project=$(select_project "$1")
            if [[ -n "$selected_project" ]]; then
                switch_to_project "$selected_project"
            fi
            ;;
    esac
}

main "$@"
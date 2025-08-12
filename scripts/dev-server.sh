#!/bin/bash

# Serveur de développement intelligent
# Détecte automatiquement le type de projet et lance le bon serveur
# Usage: dev-server.sh [port]

PORT="${1:-3000}"
PROJECT_TYPE=""

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

# Fonction pour détecter le type de projet
detect_project_type() {
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts.dev' package.json >/dev/null 2>&1; then
            PROJECT_TYPE="npm-dev"
        elif jq -e '.scripts.start' package.json >/dev/null 2>&1; then
            PROJECT_TYPE="npm-start" 
        elif jq -e '.dependencies.vite' package.json >/dev/null 2>&1; then
            PROJECT_TYPE="vite"
        elif jq -e '.dependencies.react' package.json >/dev/null 2>&1; then
            PROJECT_TYPE="react"
        elif jq -e '.dependencies.vue' package.json >/dev/null 2>&1; then
            PROJECT_TYPE="vue"
        else
            PROJECT_TYPE="node"
        fi
    elif [[ -f "Cargo.toml" ]]; then
        PROJECT_TYPE="rust"
    elif [[ -f "go.mod" ]]; then
        PROJECT_TYPE="go"
    elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
        PROJECT_TYPE="python"
    elif [[ -f "Gemfile" ]]; then
        PROJECT_TYPE="ruby"
    elif [[ -f "index.html" ]]; then
        PROJECT_TYPE="static"
    else
        PROJECT_TYPE="unknown"
    fi
}

# Fonction pour lancer le serveur selon le type de projet
start_server() {
    print_info "Type de projet détecté: $PROJECT_TYPE"
    
    case $PROJECT_TYPE in
        "npm-dev")
            print_success "Lancement avec npm run dev"
            npm run dev
            ;;
        "npm-start")
            print_success "Lancement avec npm start"
            npm start
            ;;
        "vite")
            print_success "Lancement du serveur Vite"
            npx vite --port "$PORT" --host
            ;;
        "react")
            print_success "Lancement du serveur React"
            npm start
            ;;
        "vue")
            print_success "Lancement du serveur Vue"
            npm run serve
            ;;
        "node")
            print_success "Lancement serveur Node.js simple"
            if [[ -f "server.js" ]]; then
                node server.js
            elif [[ -f "index.js" ]]; then
                node index.js
            else
                print_warning "Aucun fichier serveur trouvé"
                npx http-server -p "$PORT"
            fi
            ;;
        "rust")
            print_success "Lancement du projet Rust"
            cargo run
            ;;
        "go")
            print_success "Lancement du projet Go"
            go run .
            ;;
        "python")
            print_success "Lancement du serveur Python"
            if [[ -f "manage.py" ]]; then
                python manage.py runserver "0.0.0.0:$PORT"
            elif [[ -f "app.py" ]]; then
                python app.py
            else
                python -m http.server "$PORT"
            fi
            ;;
        "ruby")
            print_success "Lancement du serveur Ruby"
            if [[ -f "config.ru" ]]; then
                bundle exec rackup -p "$PORT"
            else
                ruby -run -e httpd . -p "$PORT"
            fi
            ;;
        "static")
            print_success "Serveur statique pour fichiers HTML"
            if command -v python3 &> /dev/null; then
                python3 -m http.server "$PORT"
            elif command -v python &> /dev/null; then
                python -m SimpleHTTPServer "$PORT"
            elif command -v npx &> /dev/null; then
                npx http-server -p "$PORT"
            else
                print_error "Aucun serveur HTTP disponible"
                exit 1
            fi
            ;;
        "unknown")
            print_warning "Type de projet non reconnu"
            print_info "Lancement d'un serveur HTTP simple"
            if command -v npx &> /dev/null; then
                npx http-server -p "$PORT"
            else
                python3 -m http.server "$PORT" 2>/dev/null || python -m SimpleHTTPServer "$PORT"
            fi
            ;;
    esac
}

# Fonction principale
main() {
    print_info "🚀 Serveur de développement intelligent"
    print_info "📁 Répertoire: $(pwd)"
    print_info "🌐 Port: $PORT"
    
    detect_project_type
    
    # Afficher l'URL locale
    if command -v hostname &> /dev/null; then
        local_ip=$(hostname -I | awk '{print $1}')
        echo ""
        print_info "📡 URLs disponibles:"
        echo "  Local:   http://localhost:$PORT"
        echo "  Réseau:  http://$local_ip:$PORT"
        echo ""
    fi
    
    start_server
}

# Aide
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Serveur de développement intelligent"
    echo ""
    echo "Usage: $0 [port]"
    echo ""
    echo "Détecte automatiquement:"
    echo "  • Projects Node.js (npm, Vite, React, Vue)"
    echo "  • Projects Rust (Cargo)"
    echo "  • Projects Go"
    echo "  • Projects Python (Django, Flask, simple)"
    echo "  • Projects Ruby (Rack, simple)"
    echo "  • Sites statiques HTML"
    echo ""
    echo "Port par défaut: 3000"
    exit 0
fi

main
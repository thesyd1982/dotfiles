# Alias et fonctions personnalisés pour workflow tmux/zoxide
# Source ce fichier dans .zshrc : source ~/dotfiles/aliases.zsh

# ========================================
# 🚀 NAVIGATION ET PROJETS
# ========================================

# Raccourcis pour tes nouveaux scripts
alias sm="session-manager"
alias pswitch="project-switch"    # Évite conflit avec ps système
alias qs="session-manager quick"  # Quick session avec zoxide

# Raccourcis tmux
alias ta="tmux attach"
alias tlist="tmux list-sessions"    # Évite conflit avec tl (Teal)
alias tk="tmux kill-session"
alias tn="tmux new-session"

# Navigation avec zoxide (tu utilises déjà 'z')
alias zz="zoxide query -l | head -20"  # Voir projets récents
alias zh="zoxide query -l"             # Historique complet

# ========================================
# 🔧 DÉVELOPPEMENT 
# ========================================

# Tes alias existants améliorés
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Sessions tmux spécialisées
alias dev="session-manager dev"        # Session de dev dans dossier courant
alias devs="session-manager dev ~"     # Session de dev à la racine

# Git workflow (complète tes alias existants)
alias gst="git status"
alias gaa="git add ."
alias gcm="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git checkout -b"
alias glog="git log --oneline -10"

# Package managers (basé sur ton usage pnpm/npm)
alias pni="pnpm install"
alias pnd="pnpm run dev"
alias pnb="pnpm run build"
alias pns="pnpm start"

alias ni="npm install"
alias nd="npm run dev"
alias nb="npm run build"
alias ns="npm start"

# ========================================
# 🛠 SYSTÈME ET UTILS
# ========================================

# Tes alias existants conservés/améliorés
alias cat="batcat"                     # Tu utilises déjà ça
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# Navigation rapide
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Utils système
alias ports="netstat -tulpn | grep LISTEN"
alias myip="curl -s ifconfig.me"
alias weather="curl -s wttr.in"

# ========================================
# 🎯 FONCTIONS AVANCÉES
# ========================================

# Créer un projet et ouvrir en session de dev
mkproject() {
    local project_name="$1"
    local project_type="${2:-node}"
    
    if [[ -z "$project_name" ]]; then
        echo "Usage: mkproject <nom> [type]"
        echo "Types: node, react, vue, go, rust, python"
        return 1
    fi
    
    local project_path="$HOME/projects/$project_name"
    
    # Créer le dossier
    mkdir -p "$project_path"
    cd "$project_path"
    
    # Initialiser selon le type
    case "$project_type" in
        "react")
            npx create-react-app . --template typescript
            ;;
        "vue")
            npm create vue@latest . -- --typescript
            ;;
        "node")
            npm init -y
            echo 'console.log("Hello World!");' > index.js
            ;;
        "go")
            go mod init "$project_name"
            echo 'package main

import "fmt"

func main() {
    fmt.Println("Hello World!")
}' > main.go
            ;;
        "rust")
            cargo init .
            ;;
        "python")
            python3 -m venv venv
            touch requirements.txt
            echo 'print("Hello World!")' > main.py
            ;;
    esac
    
    # Initialiser git
    git init
    echo "node_modules/
.env
.DS_Store
*.log" > .gitignore
    
    # Ouvrir en session de dev
    session-manager dev . "$project_name"
}

# Fonction pour basculer rapidement vers tes projets favoris
# (basée sur tes alias existants comme 'kcef')
quick_kce() {
    if [[ "$1" == "front" ]]; then
        z kce-front 2>/dev/null && session-manager dev . kce-front
    else
        z kce 2>/dev/null && session-manager dev . kce
    fi
}

# Backup rapide d'un projet
backup_project() {
    local project_path="${1:-$(pwd)}"
    local project_name=$(basename "$project_path")
    local backup_path="$HOME/backups/$project_name-$(date +%Y%m%d-%H%M%S)"
    
    echo "📦 Backup de $project_name vers $backup_path"
    
    mkdir -p "$HOME/backups"
    
    # Copier en excluant node_modules, .git, etc.
    rsync -av \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='dist' \
        --exclude='build' \
        --exclude='target' \
        --exclude='__pycache__' \
        "$project_path/" "$backup_path/"
    
    echo "✅ Backup terminé: $backup_path"
}

# Fonction pour nettoyer les node_modules
clean_node_modules() {
    local search_path="${1:-$(pwd)}"
    
    echo "🧹 Recherche des dossiers node_modules dans $search_path..."
    
    find "$search_path" -name "node_modules" -type d -exec du -sh {} \; | sort -hr
    
    echo ""
    read -p "Supprimer tous ces dossiers node_modules? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find "$search_path" -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null
        echo "✅ Nettoyage terminé!"
    fi
}

# ========================================
# 🔥 WORKFLOWS SPÉCIALISÉS
# ========================================

# Session complète pour développement full-stack
fullstack() {
    local project_name="${1:-fullstack}"
    
    # Créer session avec layout spécialisé
    tmux new-session -d -s "$project_name"
    
    # Fenêtre 1: Frontend
    tmux rename-window -t "$project_name:0" "frontend"
    tmux split-window -h -p 50
    tmux send-keys -t "$project_name:frontend.0" "echo '🎨 Frontend - Éditeur'" C-m
    tmux send-keys -t "$project_name:frontend.1" "echo '🚀 Frontend - Serveur'" C-m
    
    # Fenêtre 2: Backend
    tmux new-window -t "$project_name" -n "backend"
    tmux split-window -h -p 50
    tmux send-keys -t "$project_name:backend.0" "echo '⚙️ Backend - Éditeur'" C-m
    tmux send-keys -t "$project_name:backend.1" "echo '🔧 Backend - Serveur'" C-m
    
    # Fenêtre 3: Base de données + logs
    tmux new-window -t "$project_name" -n "database"
    tmux split-window -v -p 50
    tmux send-keys -t "$project_name:database.0" "echo '🗄️ Base de données'" C-m
    tmux send-keys -t "$project_name:database.1" "echo '📊 Logs système'" C-m
    
    # Fenêtre 4: Git et déploiement
    tmux new-window -t "$project_name" -n "deploy"
    tmux send-keys -t "$project_name:deploy" "echo '🚀 Git & Déploiement'" C-m
    
    # Retourner à la première fenêtre
    tmux select-window -t "$project_name:frontend"
    tmux attach -t "$project_name"
}

# Session pour debugging
debug_session() {
    local project_name="${1:-debug}"
    
    tmux new-session -d -s "$project_name"
    
    # Layout debugging : code + console + logs + tests
    tmux rename-window -t "$project_name:0" "debug"
    
    # Diviser en 4 panneaux
    tmux split-window -h -p 50          # Diviser verticalement
    tmux split-window -v -p 50          # Diviser le panneau droit horizontalement
    tmux select-pane -t 0               # Retourner au panneau gauche
    tmux split-window -v -p 50          # Diviser le panneau gauche horizontalement
    
    # Configurer les panneaux
    tmux send-keys -t "$project_name:debug.0" "echo '🔍 Code - Éditeur'" C-m
    tmux send-keys -t "$project_name:debug.1" "echo '🐛 Debugger/Console'" C-m
    tmux send-keys -t "$project_name:debug.2" "echo '📝 Logs Application'" C-m
    tmux send-keys -t "$project_name:debug.3" "echo '🧪 Tests'" C-m
    
    tmux attach -t "$project_name"
}

# ========================================
# 📱 RACCOURCIS SPÉCIAUX
# ========================================

# Ouvrir rapidement tes configs favorites
alias vzsh="nvim ~/.zshrc"
alias vvim="nvim ~/.config/nvim"
alias vtmux="nvim ~/.tmux.conf"
alias vdot="cd ~/dotfiles && nvim ."

# Recharger la config zsh
alias reload="source ~/.zshrc && echo '✅ Config rechargée'"

# Voir l'utilisation du disque par dossier
alias du1="du -h --max-depth=1 | sort -hr"
alias du2="du -h --max-depth=2 | sort -hr"

# Process et système
alias psg="ps aux | grep"
alias cpu="top -o %CPU"
alias mem="top -o %MEM"

# ========================================
# 🌐 RÉSEAU ET SERVICES
# ========================================

# Services (basé sur tes commandes auto-start)
alias sshup="sudo service ssh start && echo '🔐 SSH démarré'"
alias cronup="sudo service cron start && echo '⏰ Cron démarré'"

# Ports et réseau
alias port3000="lsof -ti:3000"
alias port8080="lsof -ti:8080"
# killport est remplacé par la fonction kp() plus bas

# Fonction pour tuer un port facilement
kp() {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: kp <port>"
        return 1
    fi
    
    local pid=$(lsof -ti:$port)
    if [[ -n "$pid" ]]; then
        kill -9 $pid
        echo "✅ Port $port libéré (PID: $pid)"
    else
        echo "❌ Aucun processus sur le port $port"
    fi
}

# ========================================
# 🎨 AMÉLIORATION DE TON WORKFLOW EXISTANT
# ========================================

# Améliorer ton alias 'kcef' existant
# Note: Ton alias original 'kcef' est déjà défini dans .zshrc
# Si tu veux la version améliorée, commente l'alias dans .zshrc et décommente ci-dessous

# kcef() {
#     # Si tmuxifier est disponible, utiliser ton layout existant
#     if command -v tmuxifier &> /dev/null; then
#         tmux new-session -A -s kce-front
#     else
#         # Sinon utiliser session-manager
#         z kce-front 2>/dev/null && session-manager dev . kce-front
#     fi
# }

# Version améliorée de ton workflow SSH
# Note: Remplace ton alias sshstart existant
sshsetup() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ssh -T git@github.com
    echo "✅ SSH configuré pour GitHub"
}

# Fonction pour synchroniser tes dotfiles rapidement
sync_dotfiles() {
    echo "🔄 Synchronisation des dotfiles..."
    
    cd ~/dotfiles
    git add .
    git status
    
    read -r -p "Commit et push? (y/N): " reply
    echo
    
    if [[ $reply =~ ^[Yy]$ ]]; then
        local message="${1:-Update dotfiles $(date +%Y-%m-%d)}"
        git commit -m "$message"
        git push
        echo "✅ Dotfiles synchronisés!"
    fi
}

# ========================================
# 💡 TIPS ET RACCOURCIS
# ========================================

# Afficher un tip aléatoire au démarrage (optionnel)
show_tip() {
    local tips=(
        "💡 Tip: Utilisez 'qs mon-projet' pour ouvrir rapidement un projet"
        "💡 Tip: 'mkproject mon-app react' crée un projet React avec session tmux"
        "💡 Tip: 'fullstack' crée une session tmux complète front+back+db"
        "💡 Tip: 'kp 3000' tue le processus sur le port 3000"
        "💡 Tip: 'du1' montre l'usage disque par dossier"
        "💡 Tip: 'weather' affiche la météo dans le terminal"
    )
    
    local random_tip=${tips[$RANDOM % ${#tips[@]}]}
    echo "$random_tip"
}

# Uncomment la ligne suivante pour afficher un tip au démarrage
# show_tip
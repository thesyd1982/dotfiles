#!/bin/bash

# Git Quick Commands - Commandes git rapides et intelligentes
# Usage: git-quick.sh <command> [args]

SCRIPT_NAME=$(basename "$0")

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

# Vérifier si on est dans un repo git
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Pas dans un dépôt Git"
        exit 1
    fi
}

# Fonction pour les commits rapides
quick_commit() {
    local message="$*"
    
    if [[ -z "$message" ]]; then
        print_error "Message de commit requis"
        echo "Usage: $SCRIPT_NAME commit <message>"
        exit 1
    fi
    
    print_info "Ajout de tous les fichiers..."
    git add .
    
    print_info "Commit: $message"
    git commit -m "$message"
    
    print_success "Commit créé avec succès!"
}

# Fonction pour commit et push
quick_push() {
    local message="$*"
    
    if [[ -z "$message" ]]; then
        print_error "Message de commit requis"
        echo "Usage: $SCRIPT_NAME push <message>"
        exit 1
    fi
    
    quick_commit "$message"
    
    print_info "Push vers le dépôt distant..."
    git push
    
    print_success "Code poussé avec succès!"
}

# Fonction pour synchroniser avec main/master
sync_main() {
    local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
    local current_branch=$(git branch --show-current)
    
    print_info "Synchronisation avec $main_branch..."
    
    # Sauvegarder les changements actuels si nécessaires
    if ! git diff-index --quiet HEAD --; then
        print_warning "Changements non commitées détectés"
        print_info "Stash des changements..."
        git stash push -m "Auto-stash avant sync $(date)"
        local stashed=true
    fi
    
    # Changer vers la branche principale
    git checkout "$main_branch"
    git pull origin "$main_branch"
    
    # Retourner à la branche originale si différente
    if [[ "$current_branch" != "$main_branch" ]]; then
        git checkout "$current_branch"
        print_info "Merge de $main_branch dans $current_branch..."
        git merge "$main_branch"
    fi
    
    # Restaurer les changements stashés
    if [[ "$stashed" == true ]]; then
        print_info "Restauration des changements stashés..."
        git stash pop
    fi
    
    print_success "Synchronisation terminée!"
}

# Fonction pour créer une nouvelle branche
new_branch() {
    local branch_name="$1"
    
    if [[ -z "$branch_name" ]]; then
        print_error "Nom de branche requis"
        echo "Usage: $SCRIPT_NAME branch <nom-de-branche>"
        exit 1
    fi
    
    print_info "Création de la branche: $branch_name"
    git checkout -b "$branch_name"
    
    print_success "Branche $branch_name créée et activée!"
}

# Fonction pour afficher le statut détaillé
status_detail() {
    print_info "📊 Statut détaillé du dépôt Git"
    echo ""
    
    # Informations générales
    echo "📁 Répertoire: $(pwd)"
    echo "🌿 Branche: $(git branch --show-current)"
    echo "🔗 Remote: $(git remote get-url origin 2>/dev/null || echo 'Aucun')"
    echo ""
    
    # Statut des fichiers
    print_info "📋 Statut des fichiers:"
    git status --short
    echo ""
    
    # Derniers commits
    print_info "📝 Derniers commits:"
    git log --oneline -5
    echo ""
    
    # Branches
    print_info "🌿 Branches locales:"
    git branch
}

# Fonction pour nettoyer le repo
cleanup() {
    print_info "🧹 Nettoyage du dépôt..."
    
    # Nettoyer les branches mergées
    print_info "Suppression des branches mergées..."
    git branch --merged | grep -v "\\*\\|main\\|master\\|develop" | xargs -n 1 git branch -d 2>/dev/null || true
    
    # Nettoyer les références distantes obsolètes
    print_info "Nettoyage des références distantes..."
    git remote prune origin
    
    # Nettoyer le cache Git
    print_info "Nettoyage du cache Git..."
    git gc --auto
    
    print_success "Nettoyage terminé!"
}

# Fonction d'aide
show_help() {
    echo "Git Quick Commands - Commandes Git rapides"
    echo ""
    echo "Usage: $SCRIPT_NAME <command> [args]"
    echo ""
    echo "Commandes disponibles:"
    echo "  commit <message>    Ajouter tous les fichiers et commit"
    echo "  push <message>      Commit + push vers le dépôt distant"
    echo "  sync               Synchroniser avec main/master"
    echo "  branch <name>      Créer et basculer vers une nouvelle branche"
    echo "  status             Afficher un statut détaillé"
    echo "  cleanup            Nettoyer le dépôt (branches, cache)"
    echo "  help               Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $SCRIPT_NAME commit \"Ajout de nouvelles fonctionnalités\""
    echo "  $SCRIPT_NAME push \"Fix bug critique\""
    echo "  $SCRIPT_NAME branch feature/nouvelle-fonctionnalité"
    echo "  $SCRIPT_NAME sync"
    echo "  $SCRIPT_NAME status"
}

# Parser les commandes
case "$1" in
    "commit")
        check_git_repo
        shift
        quick_commit "$@"
        ;;
    "push")
        check_git_repo
        shift
        quick_push "$@"
        ;;
    "sync")
        check_git_repo
        sync_main
        ;;
    "branch")
        check_git_repo
        new_branch "$2"
        ;;
    "status")
        check_git_repo
        status_detail
        ;;
    "cleanup")
        check_git_repo
        cleanup
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
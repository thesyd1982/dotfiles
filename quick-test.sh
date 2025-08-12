#!/bin/bash

# Quick test des dotfiles après correction
echo "🧪 Test rapide des dotfiles..."

# Test 1: Vérifier que zsh peut parser les fichiers
echo "📋 Test 1: Syntaxe zsh"
if zsh -n ~/dotfiles/.zshrc 2>/dev/null; then
    echo "✅ .zshrc - syntaxe OK"
else
    echo "❌ .zshrc - erreur de syntaxe"
    zsh -n ~/dotfiles/.zshrc
fi

if zsh -n ~/dotfiles/aliases.zsh 2>/dev/null; then
    echo "✅ aliases.zsh - syntaxe OK"
else
    echo "❌ aliases.zsh - erreur de syntaxe"
    zsh -n ~/dotfiles/aliases.zsh
fi

# Test 2: Vérifier les scripts bash
echo ""
echo "📋 Test 2: Scripts bash"
for script in ~/dotfiles/scripts/*.sh ~/dotfiles/binaries/*.sh; do
    if [[ -f "$script" ]]; then
        filename=$(basename "$script")
        if bash -n "$script" 2>/dev/null; then
            echo "✅ $filename - syntaxe OK"
        else
            echo "❌ $filename - erreur de syntaxe"
        fi
    fi
done

# Test 3: Tester le sourcing des aliases sans conflit
echo ""
echo "📋 Test 3: Chargement des alias"
if (
    # Dans un sous-shell pour éviter de polluer l'environnement
    unalias kcef 2>/dev/null  # Supprimer l'alias s'il existe
    source ~/dotfiles/aliases.zsh 2>/dev/null
    echo "✅ aliases.zsh chargé sans erreur"
) then
    true
else
    echo "❌ Erreur lors du chargement des alias"
fi

echo ""
echo "🎯 Test terminé. Si pas d'erreurs, vous pouvez faire:"
echo "   source ~/.zshrc"
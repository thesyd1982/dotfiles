#!/bin/bash

# Script de test pour vérifier la sécurité des dotfiles
# Usage: ./test_security.sh

echo "🔒 Test de sécurité des dotfiles"
echo "================================"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonction pour vérifier qu'un fichier est ignoré par git
check_git_ignore() {
    local file="$1"
    if git check-ignore "$file" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $file est ignoré par git"
        return 0
    else
        echo -e "${RED}✗${NC} $file N'EST PAS ignoré par git"
        return 1
    fi
}

# Test 1: Vérifier que .wakatime.cfg est ignoré
echo "Test 1: Vérification .gitignore"
check_git_ignore ".wakatime.cfg" || echo -e "${YELLOW}⚠${NC} Ajouter .wakatime.cfg au .gitignore"

# Test 2: Vérifier que le template existe
echo -e "\nTest 2: Template WakaTime"
if [[ -f ".wakatime.cfg.template" ]]; then
    echo -e "${GREEN}✓${NC} Template WakaTime existe"
    if grep -q "YOUR_WAKATIME_API_KEY_HERE" ".wakatime.cfg.template"; then
        echo -e "${GREEN}✓${NC} Template contient le placeholder"
    else
        echo -e "${RED}✗${NC} Template ne contient pas le placeholder"
    fi
else
    echo -e "${RED}✗${NC} Template WakaTime manquant"
fi

# Test 3: Vérifier qu'aucun secret n'est tracké
echo -e "\nTest 3: Recherche de secrets"
if git ls-files | xargs grep -l "waka_[a-f0-9-]\{8,\}" 2>/dev/null; then
    echo -e "${RED}✗${NC} API key WakaTime trouvée dans les fichiers trackés!"
else
    echo -e "${GREEN}✓${NC} Aucune API key trouvée dans les fichiers trackés"
fi

# Test 4: Vérifier les fichiers sensibles
echo -e "\nTest 4: Fichiers sensibles"
sensitive_files=(".git-credentials" ".env" ".env.local" "*.key" "*.pem")
for pattern in "${sensitive_files[@]}"; do
    if ls $pattern 2>/dev/null | head -1 >/dev/null; then
        check_git_ignore "$pattern"
    fi
done

# Test 5: Vérifier la structure du script d'installation
echo -e "\nTest 5: Script d'installation"
if [[ -f "install.sh" ]]; then
    if grep -q "setup_wakatime" "install.sh"; then
        echo -e "${GREEN}✓${NC} Script contient la fonction setup_wakatime"
    else
        echo -e "${YELLOW}⚠${NC} Script ne contient pas setup_wakatime"
    fi
    
    if grep -q "skip-wakatime" "install.sh"; then
        echo -e "${GREEN}✓${NC} Script supporte --skip-wakatime"
    else
        echo -e "${YELLOW}⚠${NC} Script ne supporte pas --skip-wakatime"
    fi
else
    echo -e "${RED}✗${NC} Script install.sh manquant"
fi

echo -e "\n🎯 Recommandations:"
echo "1. Toujours utiliser le template pour WakaTime"
echo "2. Ne jamais commiter de vraies API keys"
echo "3. Tester avec --skip-wakatime pour l'installation"
echo "4. Utiliser --backup pour sauvegarder les configs existantes"

echo -e "\n✅ Test de sécurité terminé"
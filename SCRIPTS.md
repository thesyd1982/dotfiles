# 🛠 Scripts et Outils Personnels

Ce dossier contient tous tes scripts et outils de développement personnalisés.

## 📁 Structure

```
dotfiles/
├── scripts/           # Scripts utilitaires
│   ├── browser.sh     # Ouvre URLs dans navigateur Windows depuis WSL
│   ├── ssh_start.sh   # Démarre le service SSH avec infos
│   ├── viteconf.sh    # Génère configs Vite intelligentes
│   ├── dev-server.sh  # Serveur de dev auto (détecte le type de projet)
│   └── git-quick.sh   # Commandes Git rapides
└── binaries/          # Outils de développement
    └── ide.sh         # Setup environnement tmux avec 4 panneaux
```

## 🚀 Scripts Disponibles

### `browser` - Navigateur Web
```bash
browser "https://google.com"    # Ouvre dans navigateur Windows
browser "localhost:3000"        # Ouvre serveur de dev local
```

### `ssh_start` - Service SSH  
```bash
ssh_start                       # Démarre SSH + affiche IP
```

### `viteconf` - Configuration Vite
```bash
viteconf                        # Config basique
viteconf react                  # Config pour React
viteconf vue --port 4000        # Config Vue avec port custom
viteconf --help                 # Voir toutes les options
```

### `dev-server` - Serveur de Développement
```bash
dev-server                      # Auto-détecte et lance le serveur
dev-server 4000                 # Sur le port 4000
```

**Projets supportés :**
- Node.js (npm run dev, npm start)
- Vite, React, Vue, Svelte
- Python (Django, Flask, simple HTTP)
- Go, Rust, Ruby
- Sites statiques HTML

### `git-quick` - Git Rapide
```bash
git-quick commit "Mon message"  # add . + commit
git-quick push "Fix bug"        # commit + push
git-quick sync                  # sync avec main/master
git-quick branch feature/test   # nouvelle branche
git-quick status                # statut détaillé
git-quick cleanup               # nettoyage repo
```

### `ide` - Environnement IDE
```bash
ide                             # Session dans répertoire courant
ide ~/projects/mon-app          # Session dans projet spécifique
ide ~/projects/mon-app dev      # Session avec nom custom
```

**Layout créé :**
```
┌─────────────┬─────────┐
│             │ TERM1   │
│   NEOVIM    │ (dev)   │
│ (éditeur)   ├─────────┤
│             │ TERM2   │
├─────────────┤ (git)   │
│ TERM3 (logs)│         │
└─────────────┴─────────┘
```

## 📦 Installation

Les scripts sont automatiquement installés dans `~/.local/bin` lors de l'installation des dotfiles :

```bash
./install.sh
```

Ils deviennent alors disponibles partout dans ton terminal !

## 🔧 Personnalisation

### Ajouter un nouveau script

1. **Créer le script** dans `scripts/` ou `binaries/`
2. **Le rendre exécutable** : `chmod +x mon-script.sh`
3. **Mettre à jour `.gitignore`** si nécessaire
4. **Réinstaller** : `./install.sh`

### Modifier un script existant

1. **Éditer le fichier** dans `dotfiles/scripts/` ou `dotfiles/binaries/`
2. **Réinstaller** : `./install.sh` (écrase les anciens)

## 💡 Tips

### Alias utiles à ajouter dans `.zshrc`
```bash
# Raccourcis pour tes scripts les plus utilisés
alias serve="dev-server"
alias tmux-ide="ide"
alias gc="git-quick commit"
alias gp="git-quick push"
alias gs="git-quick status"
```

### Variables d'environnement
Ajoute dans `.zshenv` pour personnaliser :
```bash
export DEFAULT_DEV_PORT=3000
export PREFERRED_BROWSER="firefox"
export TMUX_IDE_LAYOUT="main-vertical"
```

---

**🎯 Tous ces outils sont conçus pour accélérer ton workflow de développement !**
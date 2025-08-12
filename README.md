# 🏠 Dotfiles de thesyd

Configuration complète d'environnement de développement pour Ubuntu/WSL avec Zsh, Neovim, Tmux et plus.

## 🚀 Installation Rapide

```bash
git clone https://github.com/ton-username/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

## 🎯 Ce qui est inclus

- **Shell** : Zsh + Oh-My-Zsh + Powerlevel10k
- **Éditeur** : Neovim avec LazyVim 
- **Terminal** : Tmux avec configuration personnalisée
- **Git** : Configuration et alias optimisés
- **Développement** : Node.js, Go, Rust, Python
- **Monitoring** : WakaTime (optionnel)

## 📦 Installation

### Options disponibles

```bash
# Installation complète
./install.sh

# Installation avec backup des configs existantes
./install.sh --backup

# Installation sans WakaTime
./install.sh --skip-wakatime

# Voir toutes les options
./install.sh --help
```

### Configuration WakaTime

Si tu veux utiliser WakaTime pour tracker ton temps de dev :

1. Va sur [wakatime.com/api-key](https://wakatime.com/api-key)
2. Copie ton API key
3. Lance l'installation normalement, elle te demandera l'API key

Ou ignore WakaTime avec `--skip-wakatime`.

## 🔧 Structure

```
dotfiles/
├── .config/nvim/          # Configuration Neovim + LazyVim
├── scripts/               # Scripts utilitaires
├── binaries/             # Outils personnels
├── custom/               # Plugins Oh-My-Zsh personnalisés
├── themes/               # Thèmes Oh-My-Zsh personnalisés
├── .zshrc               # Configuration Zsh
├── .tmux.conf           # Configuration Tmux
├── .gitconfig           # Configuration Git
├── .wakatime.cfg.template # Template WakaTime (sans API key)
└── install.sh           # Script d'installation
```

## 🔒 Sécurité

- ✅ **Aucun secret** n'est commité dans ce repo
- ✅ Les API keys sont gérées via templates
- ✅ `.git-credentials` est ignoré
- ✅ Backup automatique des configs existantes

## 🛠 Logiciels installés

Le script d'installation installe automatiquement :

- Zsh + Oh-My-Zsh
- Neovim (version stable depuis les sources)
- Tmux 
- Node.js (LTS)
- Go
- Rust + Cargo
- Build tools essentiels

## 📝 Personnalisation

### Ajouter tes propres configs

1. Ajoute tes fichiers dans le repo
2. Mets à jour `.gitignore` si nécessaire
3. Modifie `install.sh` pour créer les liens symboliques

### WakaTime

Le fichier `.wakatime.cfg.template` contient la structure de base.
Ton API key personnelle sera demandée à l'installation.

## 🔄 Mise à jour

```bash
cd ~/dotfiles
git pull
./install.sh --backup  # Recommandé pour backup
```

## 🐛 Dépannage

### Le shell ne change pas
```bash
chsh -s $(which zsh)
# Puis redémarre ta session
```

### Neovim ne trouve pas les configs
```bash
# Vérifier le lien
ls -la ~/.config/nvim
# Relancer l'installation si nécessaire
```

### WakaTime ne fonctionne pas
```bash
# Vérifier la config
cat ~/.wakatime.cfg
# Reconfigurer si nécessaire
rm ~/.wakatime.cfg && ./install.sh
```

## 🤝 Contribution

N'hésite pas à forker, modifier et proposer des améliorations !

## 📄 Licence

MIT - Utilise comme tu veux !

---

**Setup testé sur** : Ubuntu 20.04+, WSL2, Ubuntu Server

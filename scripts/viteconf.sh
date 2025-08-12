#!/usr/bin/env bash

# Script pour générer un fichier vite.config.js
# Usage: viteconf.sh [framework] [options]
# Exemples: 
#   viteconf.sh                    # Config basique
#   viteconf.sh react             # Config pour React
#   viteconf.sh vue               # Config pour Vue
#   viteconf.sh --port 4000       # Avec port personnalisé

FRAMEWORK=""
PORT="3000"
OUTPUT_FILE="vite.config.js"

# Parser les arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        react|vue|vanilla|svelte)
            FRAMEWORK="$1"
            shift
            ;;
        --port)
            PORT="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [framework] [options]"
            echo ""
            echo "Frameworks supportés:"
            echo "  react, vue, vanilla, svelte"
            echo ""
            echo "Options:"
            echo "  --port <number>     Port de développement (défaut: 3000)"
            echo "  --output -o <file>  Nom du fichier de sortie (défaut: vite.config.js)"
            echo "  --help -h          Afficher cette aide"
            echo ""
            echo "Exemples:"
            echo "  $0                     # Config basique"
            echo "  $0 react --port 4000  # React avec port 4000"
            echo "  $0 vue -o vite.dev.js # Vue avec fichier custom"
            exit 0
            ;;
        *)
            echo "❌ Option inconnue: $1"
            echo "💡 Utilisez --help pour voir les options disponibles"
            exit 1
            ;;
    esac
done

# Vérifier si le fichier existe déjà
if [[ -f "$OUTPUT_FILE" ]]; then
    echo "⚠️  Le fichier $OUTPUT_FILE existe déjà"
    read -p "🤔 Voulez-vous l'écraser? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Opération annulée"
        exit 0
    fi
fi

# Générer la configuration selon le framework
echo "📝 Génération de $OUTPUT_FILE pour ${FRAMEWORK:-'vanilla'}..."

case $FRAMEWORK in
    react)
        cat > "$OUTPUT_FILE" << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: $PORT,
    open: true,
    host: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  }
})
EOF
        ;;
    vue)
        cat > "$OUTPUT_FILE" << EOF
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: $PORT,
    open: true,
    host: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  }
})
EOF
        ;;
    svelte)
        cat > "$OUTPUT_FILE" << EOF
import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

export default defineConfig({
  plugins: [svelte()],
  server: {
    port: $PORT,
    open: true,
    host: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  }
})
EOF
        ;;
    *)
        cat > "$OUTPUT_FILE" << EOF
import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    port: $PORT,
    open: true,
    host: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  }
})
EOF
        ;;
esac

echo "✅ Fichier $OUTPUT_FILE créé avec succès!"
echo "🚀 Démarrez votre projet avec: npm run dev"

# Afficher le contenu généré
echo ""
echo "📄 Contenu généré:"
echo "---"
cat "$OUTPUT_FILE"
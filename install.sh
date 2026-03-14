#!/bin/bash

# ============================================
# Insta Scraper Skill — Instalador
# Skill para Claude Code que baixa posts do
# Instagram com filtros avançados
# ============================================

set -e

echo ""
echo "=========================================="
echo "  INSTA SCRAPER SKILL — Instalação"
echo "=========================================="
echo ""

# 1. Verificar Claude Code
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code não encontrado."
    echo "   Instale em: https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi
echo "✅ Claude Code encontrado"

# 2. Verificar Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 não encontrado."
    echo "   Instale em: https://www.python.org/downloads/"
    exit 1
fi
echo "✅ Python 3 encontrado"

# 3. Instalar Instaloader
echo ""
echo "📦 Instalando Instaloader..."
pip3 install instaloader --quiet
echo "✅ Instaloader instalado"

# 4. Copiar skill para ~/.claude/skills/
SKILL_DIR="$HOME/.claude/skills/insta-scraper"
mkdir -p "$SKILL_DIR"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "✅ Skill copiada para $SKILL_DIR"

# 5. Fazer login no Instagram
echo ""
echo "=========================================="
echo "  LOGIN NO INSTAGRAM"
echo "=========================================="
echo ""
echo "Agora você precisa fazer login no Instagram"
echo "para o Instaloader poder baixar os posts."
echo ""
read -p "📝 Digite seu username do Instagram (sem @): " IG_USER

if [ -z "$IG_USER" ]; then
    echo "❌ Username não pode ser vazio."
    exit 1
fi

echo ""
echo "🔐 Fazendo login como @$IG_USER..."
echo "   (sua senha será pedida abaixo)"
echo ""

python3 -c "
import instaloader
L = instaloader.Instaloader()
L.interactive_login('$IG_USER')
L.save_session_to_file()
print()
print('✅ Login realizado e sessão salva!')
"

# 6. Finalização
echo ""
echo "=========================================="
echo "  ✅ INSTALAÇÃO COMPLETA!"
echo "=========================================="
echo ""
echo "Como usar:"
echo ""
echo "  1. Abra o Claude Code"
echo "  2. Digite: /insta-scraper nomedoperfil"
echo "  3. Responda as perguntas (formato, quantidade, filtros)"
echo "  4. Aguarde o download"
echo ""
echo "Exemplos:"
echo "  /insta-scraper brandsdecoded__"
echo "  /insta-scraper https://www.instagram.com/mkt_insider_"
echo "  /insta-scraper perfil1 perfil2"
echo ""
echo "Os posts serão salvos em: ~/Downloads/insta-scraper/"
echo ""

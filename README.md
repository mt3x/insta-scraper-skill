# Insta Scraper Skill

Skill para [Claude Code](https://docs.anthropic.com/en/docs/claude-code) que baixa posts do Instagram com filtros avançados.

Escolha o tipo de post (carrosséis, imagens, reels), quantidade e engajamento mínimo — o Claude faz o resto.

## O que faz

- Baixa posts de qualquer perfil público do Instagram
- Filtra por **formato**: carrosséis, imagens, reels ou todos
- Filtra por **engajamento**: sem mínimo, 1k+, 5k+ ou 10k+ likes
- Filtra por **quantidade**: 50, 100, 200 ou todos os posts
- Salva imagens (slides individuais), captions e metadados
- Tudo via conversa com o Claude — sem precisar decorar comandos

## Pré-requisitos

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) instalado (requer assinatura Pro, Max ou API key)
- Python 3
- Uma conta no Instagram

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/insta-scraper-skill.git
cd insta-scraper-skill
```

### 2. Rode o instalador

```bash
chmod +x install.sh
./install.sh
```

O instalador vai:
1. Verificar se você tem Claude Code e Python 3
2. Instalar o [Instaloader](https://github.com/instaloader/instaloader) (ferramenta open-source)
3. Copiar a skill para `~/.claude/skills/insta-scraper/`
4. Fazer login no Instagram e salvar a sessão localmente

### Instalação manual (alternativa)

Se preferir instalar manualmente:

```bash
# Instalar dependência
pip3 install instaloader

# Copiar a skill
mkdir -p ~/.claude/skills/insta-scraper
cp SKILL.md ~/.claude/skills/insta-scraper/

# Fazer login no Instagram (rodar no terminal)
python3 -c "
import instaloader
L = instaloader.Instaloader()
L.interactive_login('seu_usuario')
L.save_session_to_file()
"
```

## Como usar

Abra o Claude Code e digite:

```
/insta-scraper nomedoperfil
```

### Exemplos

```
/insta-scraper brandsdecoded__
/insta-scraper https://www.instagram.com/mkt_insider_
/insta-scraper perfil1 perfil2
```

### O que acontece

1. O Claude pergunta o que você quer baixar:
   - **Formato**: Carrosséis, Imagens, Reels ou Todos
   - **Quantidade**: 50, 100, 200 ou Todos
   - **Engajamento mínimo**: Sem filtro, 1k+, 5k+ ou 10k+
2. Monta o comando com os filtros escolhidos
3. Executa o download
4. Entrega relatório com contagem de posts, imagens e tamanho

### Onde ficam os arquivos

```
~/Downloads/insta-scraper/
└── nomedoperfil/
    ├── 2026-03-13_21-15-42_UTC_1.jpg   ← slide 1
    ├── 2026-03-13_21-15-42_UTC_2.jpg   ← slide 2
    ├── 2026-03-13_21-15-42_UTC.txt     ← caption
    └── ...
```

## Segurança

- Sua senha do Instagram **não é armazenada** — apenas um cookie de sessão é salvo localmente em `~/.config/instaloader/`
- Nenhum dado é enviado para servidores externos
- O Instaloader é open-source com +8k stars no GitHub

## Tecnologias

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — CLI de IA da Anthropic
- [Instaloader](https://github.com/instaloader/instaloader) — Ferramenta open-source para download do Instagram
- Python 3

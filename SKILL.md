# insta-scraper

Baixa posts do Instagram de qualquer perfil público com filtros avançados usando Instaloader.

## Trigger

Use quando o usuário mencionar 'insta-scraper', 'baixar instagram', 'scraping instagram', 'baixar posts', 'baixar carrosséis', 'baixar reels', ou '/insta-scraper'.

## Input

`/insta-scraper [link ou username do perfil]`

Exemplos:
- `/insta-scraper https://www.instagram.com/brandsdecoded__`
- `/insta-scraper brandsdecoded__`
- `/insta-scraper brandsdecoded__ mkt_insider_` (múltiplos perfis)

## Workflow

### Passo 1 — Extrair username(s)

Extrair o(s) username(s) do input. Se vier como URL, extrair do path. Aceitar múltiplos perfis separados por espaço.

### Passo 2 — Perguntar preferências ao usuário

Usar AskUserQuestion para coletar as preferências. Fazer **3 perguntas**:

**Pergunta 1 — Formato dos posts:**
- header: "Formato"
- question: "Quais tipos de post quer baixar?"
- multiSelect: true
- options:
  - "Carrosséis" (description: "Posts com múltiplos slides (GraphSidecar)")
  - "Imagens" (description: "Posts de imagem única (GraphImage)")
  - "Reels/Vídeos" (description: "Vídeos e Reels (GraphVideo)")
  - "Todos" (description: "Todos os formatos sem filtro")

**Pergunta 2 — Quantidade:**
- header: "Quantidade"
- question: "Quantos posts quer baixar (por perfil)?"
- multiSelect: false
- options:
  - "50 posts"
  - "100 posts"
  - "200 posts"
  - "Todos os posts"

**Pergunta 3 — Filtro de engajamento:**
- header: "Engajamento"
- question: "Quer filtrar por engajamento mínimo?"
- multiSelect: false
- options:
  - "Sem filtro" (description: "Baixa todos, sem mínimo de likes")
  - "1.000+ likes"
  - "5.000+ likes"
  - "10.000+ likes"

### Passo 3 — Verificar sessão do Instaloader

Verificar se existe sessão salva:
```bash
ls ~/.config/instaloader/session-* 2>/dev/null
```

Se não existir sessão, informar o usuário que precisa fazer login primeiro:
1. Criar o script `login_instagram.py` na pasta de output
2. Pedir pro usuário rodar no terminal: `python3 login_instagram.py`
3. Aguardar confirmação antes de continuar

### Passo 4 — Montar e executar o comando

Montar o comando Instaloader baseado nas respostas:

**Base do comando:**
```bash
instaloader --login USUARIO_SESSAO --dirname-pattern="{profile}" --FILTROS -- PERFIL_ALVO
```

**Mapear respostas para flags:**

Formato → `--post-filter`:
- Carrosséis: `typename == 'GraphSidecar'`
- Imagens: `typename == 'GraphImage'`
- Reels/Vídeos: `is_video`
- Todos: sem filtro de tipo
- Múltiplos: combinar com `or` → `typename == 'GraphSidecar' or typename == 'GraphImage'`

Se o formato NÃO incluir Reels/Vídeos, adicionar: `--no-videos --no-video-thumbnails`

Quantidade → `--count N`:
- 50/100/200: usar `--count N`
- Todos: não usar --count

Engajamento → adicionar ao `--post-filter` com `and`:
- Sem filtro: nada
- 1.000+: `and likes > 1000`
- 5.000+: `and likes > 5000`
- 10.000+: `and likes > 10000`

**Exemplo de comando montado:**
```bash
cd ~/Downloads/insta-scraper && instaloader \
  --login metodomodeloshot \
  --no-videos --no-video-thumbnails \
  --count 100 \
  --post-filter="typename == 'GraphSidecar' and likes > 5000" \
  --dirname-pattern="{profile}" \
  -- brandsdecoded__
```

**Pasta de saída:** `~/Downloads/insta-scraper/`

### Passo 5 — Executar

1. Criar pasta de saída: `mkdir -p ~/Downloads/insta-scraper`
2. Rodar o comando via Bash com timeout de 600000ms
3. Se o Instaloader der rate limit (401/403), informar o usuário e sugerir aguardar ou reduzir a quantidade

### Passo 6 — Relatório final

Ao concluir, exibir resumo:
- Quantos posts baixados por perfil
- Quantas imagens totais
- Tamanho da pasta
- Caminho completo dos arquivos

Usar comandos:
```bash
ls PASTA/*.jpg 2>/dev/null | wc -l  # imagens
ls PASTA/*.txt 2>/dev/null | wc -l  # captions
du -sh PASTA/                        # tamanho
```

## Dependências

- Python 3
- Instaloader: `pip3 install instaloader`
- Sessão salva em `~/.config/instaloader/session-*`

## Notas

- Sempre usar timeout de 600000ms nos comandos de download (pode demorar)
- O Instaloader já tem delays automáticos pra evitar bloqueios
- Sem login: limite de ~12 posts antes de rate limit
- Com login: centenas/milhares de posts
- Perfis privados: só funciona se o usuário da sessão seguir o perfil

# Guia Completo do Instaloader

## O que é

O Instaloader é uma ferramenta gratuita e open-source (Python) que baixa conteúdo do Instagram direto pro seu computador. Ele acessa o Instagram como se fosse um navegador, extrai os dados dos posts e salva tudo localmente em pastas organizadas.

GitHub oficial: https://github.com/instaloader/instaloader

---

## O que ele faz

- Baixa **fotos** de posts (incluindo todos os slides de carrosséis)
- Baixa **vídeos** e **reels**
- Baixa **stories** e **highlights**
- Salva as **captions** (texto do post) em arquivos .txt
- Salva **metadados** (likes, comentários, data) em arquivos .json
- Baixa **foto de perfil**
- Funciona com perfis públicos sem login
- Com login, acessa mais conteúdo e evita rate limits

---

## Instalação e Setup Inicial (passo a passo)

Siga esses passos na ordem. Leva menos de 5 minutos.

### Passo 1 — Verificar o Python 3

O Instaloader precisa do Python 3 instalado. Abra o **Terminal** e rode:

```bash
python3 --version
```

Se aparecer algo como `Python 3.x.x`, está pronto. Se der erro:

- **Mac:** O Python 3 já vem instalado na maioria dos Macs recentes. Se não tiver, instale com: `brew install python3` (precisa do [Homebrew](https://brew.sh))
- **Windows:** Baixe em [python.org/downloads](https://www.python.org/downloads/). Na instalação, marque a opção **"Add Python to PATH"**
- **Linux:** `sudo apt install python3 python3-pip`

### Passo 2 — Instalar o Instaloader

No terminal, rode:

```bash
pip3 install instaloader
```

Para confirmar que instalou corretamente:

```bash
instaloader --version
```

Deve aparecer o número da versão (ex: `4.15`).

> **Deu erro no pip3?** Tente `python3 -m pip install instaloader`

### Passo 3 — Fazer login no Instagram

Sem login, o Instagram limita a ~12 posts antes de bloquear. Com login, você consegue baixar centenas ou milhares.

**Crie um arquivo chamado `login.py`** com este conteúdo:

```python
import instaloader

L = instaloader.Instaloader()
L.interactive_login("SEU_USUARIO_AQUI")  # troque pelo seu @
L.save_session_to_file()
print("Sessão salva com sucesso!")
```

> Troque `SEU_USUARIO_AQUI` pelo seu username do Instagram (sem o @).

**Rode no terminal:**

```bash
python3 login.py
```

Ele vai pedir sua senha. Digite e aperte Enter (a senha não aparece na tela, é normal).

Se der certo, aparece: `Sessão salva com sucesso!`

> **Importante:** Você só precisa fazer isso **uma vez**. A sessão fica salva em `~/.config/instaloader/session-SEU_USUARIO` e todos os próximos comandos usam ela automaticamente.

> **Autenticação de dois fatores (2FA):** Se sua conta tem 2FA ativado, o Instaloader vai pedir o código após a senha. É só digitar o código que chega no seu celular.

### Passo 4 — Testar se tudo funciona

Rode este comando (troque `seu_usuario` pelo username que usou no login):

```bash
instaloader --login seu_usuario --count 3 -- instagram
```

Isso baixa 3 posts do perfil @instagram. Se funcionar, você vai ver arquivos sendo salvos numa pasta chamada `instagram/`.

Se funcionou, **setup completo!** Pode apagar a pasta de teste:

```bash
rm -rf instagram/
```

### Resumo do setup

| Passo | Comando | O que faz |
|---|---|---|
| 1 | `python3 --version` | Verifica se tem Python 3 |
| 2 | `pip3 install instaloader` | Instala a ferramenta |
| 3 | `python3 login.py` | Faz login e salva sessão |
| 4 | `instaloader --login user --count 3 -- instagram` | Testa se tudo funciona |

---

## Como usar

### 1. Baixar posts de um perfil

```bash
instaloader --login seu_usuario -- nomedoperfil
```

Exemplo:
```bash
instaloader --login seu_usuario -- brandsdecoded__
```

Isso cria uma pasta `brandsdecoded__/` com todos os posts (fotos + captions + metadados).

> **Sempre use `--login`** pra evitar o rate limit de ~12 posts.

---

### 2. Limitar quantidade de posts

```bash
instaloader --login seu_usuario --count 50 -- perfil_alvo
```

Baixa apenas os **50 posts mais recentes**.

---

### 3. Baixar só fotos (sem vídeos)

```bash
instaloader --login seu_usuario --no-videos --no-video-thumbnails -- perfil_alvo
```

Ideal pra análise de carrosséis — ignora reels e vídeos.

---

### 4. Organizar em pasta personalizada

```bash
instaloader --login seu_usuario --dirname-pattern="{profile}" -- perfil_alvo
```

Cria a pasta com o nome do perfil. Outras opções:
- `{profile}` → nome do perfil
- `{date_utc}` → data do post
- `{shortcode}` → código único do post

---

### 5. Baixar posts mais recentes que uma data

```bash
instaloader --login seu_usuario --post-filter="date_utc > datetime(2025,1,1)" -- perfil_alvo
```

Baixa só posts de 2025 em diante.

---

### 6. Baixar stories

```bash
instaloader --login seu_usuario --stories -- perfil_alvo
```

---

### 7. Baixar highlights

```bash
instaloader --login seu_usuario --highlights -- perfil_alvo
```

---

### 8. Baixar um post específico (por URL)

```bash
instaloader -- -BXXXXXX
```

O código após `/p/` na URL do post. Exemplo:
- URL: `https://www.instagram.com/p/ABC123xyz/`
- Comando: `instaloader -- -ABC123xyz`

---

### 9. Baixar por hashtag

```bash
instaloader --login seu_usuario "#marketingdigital"
```

---

## Exemplos de comandos completos (copiar e colar)

### Baixar os 100 carrosséis mais recentes de um perfil (sem vídeos)
```bash
instaloader \
  --login seu_usuario \
  --no-videos \
  --no-video-thumbnails \
  --count 100 \
  --post-filter="typename == 'GraphSidecar'" \
  --dirname-pattern="{profile}" \
  -- perfil_alvo
```

### Baixar reels virais (100k+ views) de um perfil
```bash
instaloader \
  --login seu_usuario \
  --count 50 \
  --post-filter="is_video and video_view_count > 100000" \
  --dirname-pattern="{profile}" \
  -- perfil_alvo
```

### Baixar tudo de um perfil (fotos + vídeos + captions + metadados)
```bash
instaloader \
  --login seu_usuario \
  --dirname-pattern="{profile}" \
  -- perfil_alvo
```

---

## O que ele salva em cada post

Para cada post, o Instaloader cria estes arquivos:

| Arquivo | Conteúdo |
|---|---|
| `2026-03-13_21-15-42_UTC_1.jpg` | Slide 1 do carrossel |
| `2026-03-13_21-15-42_UTC_2.jpg` | Slide 2 do carrossel |
| `2026-03-13_21-15-42_UTC_3.jpg` | Slide 3... e assim por diante |
| `2026-03-13_21-15-42_UTC.txt` | Caption (texto do post) |
| `2026-03-13_21-15-42_UTC.json` | Metadados (likes, comments, data, tipo) |

O nome do arquivo segue o padrão: `DATA_HORA_UTC_SLIDE.extensão`

---

## Flags mais úteis (referência rápida)

| Flag | O que faz |
|---|---|
| `--login USUARIO` | Usa sessão autenticada |
| `--count N` | Limita a N posts |
| `--no-videos` | Ignora vídeos/reels |
| `--no-video-thumbnails` | Não baixa thumbnails de vídeos |
| `--no-metadata-json` | Não salva arquivo .json |
| `--no-captions` | Não salva arquivo .txt |
| `--no-profile-pic` | Não baixa foto de perfil |
| `--stories` | Baixa stories |
| `--highlights` | Baixa highlights |
| `--dirname-pattern="{profile}"` | Nome da pasta de saída |
| `--post-filter="CONDIÇÃO"` | Filtra posts por condição |
| `--fast-update` | Para quando encontra post já baixado |

---

## Filtros: como baixar só o que você quer

O Instaloader tem a flag `--post-filter` que aceita condições escritas em Python. Ele passa por cada post do perfil, avalia a condição, e só baixa se for `True`.

### Sintaxe básica

```bash
instaloader --login seu_usuario --post-filter="CONDIÇÃO" -- perfil_alvo
```

A condição vai entre aspas duplas e usa variáveis do post (likes, comments, typename, etc).

---

### Variáveis disponíveis pra filtro

| Variável | O que é | Exemplo de valor |
|---|---|---|
| `likes` | Número de curtidas | `42350` |
| `comments` | Número de comentários | `385` |
| `is_video` | Se é vídeo/reel | `True` ou `False` |
| `video_view_count` | Views do vídeo/reel | `150000` |
| `typename` | Tipo do post | `'GraphImage'`, `'GraphSidecar'`, `'GraphVideo'` |
| `date_utc` | Data de publicação (UTC) | `datetime(2025,6,15)` |
| `caption` | Texto completo do post | `"Sua marca precisa..."` |
| `mediacount` | Número de slides (carrosséis) | `10` |
| `caption_hashtags` | Lista de hashtags | `['marketing', 'branding']` |
| `caption_mentions` | Lista de menções | `['nike', 'adidas']` |
| `is_sponsored` | Se é post patrocinado | `True` ou `False` |

### Tipos de post (typename)

| Valor | Significa |
|---|---|
| `'GraphImage'` | Post de imagem única |
| `'GraphSidecar'` | Carrossel (múltiplos slides) |
| `'GraphVideo'` | Vídeo ou Reel |

---

### Operadores que você pode usar

| Operador | Significado | Exemplo |
|---|---|---|
| `>` | Maior que | `likes > 5000` |
| `<` | Menor que | `comments < 100` |
| `>=` | Maior ou igual | `likes >= 10000` |
| `==` | Igual a | `typename == 'GraphSidecar'` |
| `!=` | Diferente de | `typename != 'GraphVideo'` |
| `and` | E (ambas condições) | `likes > 5000 and comments > 200` |
| `or` | Ou (uma das condições) | `likes > 10000 or comments > 1000` |
| `not` | Negação | `not is_video` |
| `in` | Contém | `'marketing' in caption.lower()` |

---

### Exemplos práticos (copiar e colar)

#### Só carrosséis
```bash
instaloader --login seu_usuario \
  --post-filter="typename == 'GraphSidecar'" \
  -- perfil_alvo
```

#### Só reels com mais de 100k views
```bash
instaloader --login seu_usuario \
  --post-filter="is_video and video_view_count > 100000" \
  -- perfil_alvo
```

#### Só carrosséis com mais de 5k likes
```bash
instaloader --login seu_usuario \
  --post-filter="typename == 'GraphSidecar' and likes > 5000" \
  -- perfil_alvo
```

#### Posts com mais de 500 comentários
```bash
instaloader --login seu_usuario \
  --post-filter="comments > 500" \
  -- perfil_alvo
```

#### Carrosséis com 10 slides (máximo)
```bash
instaloader --login seu_usuario \
  --post-filter="typename == 'GraphSidecar' and mediacount == 10" \
  -- perfil_alvo
```

#### Posts de 2025 em diante
```bash
instaloader --login seu_usuario \
  --post-filter="date_utc > datetime(2025,1,1)" \
  -- perfil_alvo
```

#### Posts que mencionam uma palavra na caption
```bash
instaloader --login seu_usuario \
  --post-filter="'branding' in caption.lower()" \
  -- perfil_alvo
```

#### Carrosséis recentes com alto engajamento
```bash
instaloader --login seu_usuario \
  --post-filter="typename == 'GraphSidecar' and likes > 3000 and date_utc > datetime(2025,6,1)" \
  -- perfil_alvo
```

#### Tudo MENOS vídeos (só imagens e carrosséis)
```bash
instaloader --login seu_usuario \
  --post-filter="not is_video" \
  -- perfil_alvo
```

#### Reels virais (100k+ views) OU posts com 10k+ likes
```bash
instaloader --login seu_usuario \
  --post-filter="(is_video and video_view_count > 100000) or likes > 10000" \
  -- perfil_alvo
```

---

### Combinando filtros com outras flags

Você pode usar `--post-filter` junto com qualquer outra flag:

```bash
instaloader \
  --login seu_usuario \
  --post-filter="typename == 'GraphSidecar' and likes > 5000" \
  --count 50 \
  --no-videos \
  --no-video-thumbnails \
  --dirname-pattern="{profile}" \
  -- perfil_alvo
```

Esse comando:
1. Faz login com sua conta
2. Filtra só carrosséis com 5k+ likes
3. Para depois de 50 posts que passarem no filtro
4. Não baixa vídeos
5. Salva na pasta com nome do perfil

---

### Dica: como montar seu filtro

1. **Escolha o tipo de post:** `typename == 'GraphSidecar'` (carrossel), `is_video` (reel), `not is_video` (imagem)
2. **Adicione métrica de engajamento:** `and likes > 5000` ou `and comments > 200`
3. **Adicione período se quiser:** `and date_utc > datetime(2025,1,1)`
4. **Junte tudo com `and`**

Fórmula geral:
```
TIPO + ENGAJAMENTO + PERÍODO
```

Exemplo:
```
typename == 'GraphSidecar' and likes > 3000 and date_utc > datetime(2025,6,1)
```

---

## Dicas importantes

1. **Rate limit:** Sem login, o Instagram bloqueia após ~12 posts. Com login, consegue centenas.
2. **Sessão salva:** Depois do primeiro login, a sessão fica em `~/.config/instaloader/session-USUARIO`. Não precisa logar de novo.
3. **Atualizar perfil:** Use `--fast-update` pra baixar só posts novos (para quando encontra um já baixado).
4. **Perfis privados:** Só funciona se você seguir o perfil (com login).
5. **Não abuse:** Muitas requisições em pouco tempo = bloqueio temporário. O Instaloader já tem delays automáticos.

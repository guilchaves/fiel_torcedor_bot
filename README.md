# Fiel Torcedor Bot

Um bot de Telegram que monitora o site do [Fiel Torcedor](https://www.fieltorcedor.com.br)
em busca de jogos do Corinthians e envia um alerta assim que os ingressos entram
à venda. Ele faz o scraping da listagem, guarda o que já anunciou e só notifica
sobre jogos que passaram a estar disponíveis, para você não receber mensagens
repetidas.

## Sobre esta reescrita

Esta é uma reescrita do [`guilchaves/fieltorcedor-scraper`](https://github.com/guilchaves/fieltorcedor-scraper),
que é escrito em Go usando arquitetura hexagonal. Esta versão é escrita em
**OCaml** e organizada em torno do padrão **functional core, imperative shell**
(núcleo funcional, casca imperativa), como um esforço para aprender programação
funcional.

A ideia por trás do padrão:

- O **functional core** é puro. Ele contém o modelo de domínio, o parsing do
  HTML e a decisão sobre o que alertar. Não realiza nenhum I/O, então é
  determinístico e fácil de testar com fixtures simples.
- A **imperative shell** é uma camada fina de adaptadores (HTTP, armazenamento em
  arquivo, Telegram, configuração por ambiente) mais a orquestração que busca os
  dados, os entrega ao núcleo e então executa os efeitos que o núcleo decidiu.

## Estrutura de diretórios

```
core/                  núcleo funcional: puro, sem I/O
  game.ml/.mli           tipos de domínio e predicados
  scrape.ml/.mli         string HTML -> lista de jogos (lambdasoup + seletores CSS)
  decision.ml/.mli       {seen; games} -> {alert; newly_seen}
shell/                 casca imperativa: adaptadores e orquestração
  config.ml              leitura de variáveis de ambiente
  store.ml               leitura/escrita do seen.txt (estado de deduplicação)
  http.ml                wrappers get / post_json do ezcurl
  telegram.ml            monta o payload e o envia
  main.ml                apenas a orquestração
test/
  test_fiel_bot.ml       testes puros do núcleo
```

## Requisitos

- OCaml e [dune](https://dune.build/) (>= 3.24)
- Dependências de bibliotecas: `lambdasoup`, `ezcurl`, `yojson`

Instale as dependências com o opam:

```sh
opam install dune lambdasoup ezcurl yojson
```

## Configuração

O bot lê duas variáveis de ambiente para alcançar o seu chat no Telegram:

- `TELEGRAM_BOT_TOKEN` — o token do [@BotFather](https://t.me/BotFather)
- `TELEGRAM_CHAT_ID` — o chat para onde enviar os alertas

```sh
export TELEGRAM_BOT_TOKEN=123456:seu-token
export TELEGRAM_CHAT_ID=seu-chat-id
```

## Executando

Compile o projeto:

```sh
dune build
```

Rode o bot uma vez (ele busca o site, verifica se há jogos recém-disponíveis e
alerta caso existam):

```sh
dune exec fiel_bot
```

Os jogos já anunciados ficam registrados em um arquivo local `seen.txt`, para
não serem alertados duas vezes. Para verificações periódicas, execute-o de forma
agendada (por exemplo, com `cron` ou um timer do systemd).

## Testes

```sh
dune test
```

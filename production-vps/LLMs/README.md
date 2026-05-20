# VPS LLM Services

This folder contains LLM-facing services and shared support files for the VPS.

## Layout

| Path | Purpose |
| --- | --- |
| `lobe-chat/` | LobeChat web app, database, Redis, and SearXNG deployment. |
| `all-llm-keys.env.example` | Safe provider-key template. Copy to `all-llm-keys.env` on the VPS. |
| `justfile` | Optional shared LLM network management recipes. |

## Secret handling

`all-llm-keys.env` is intentionally ignored because it contains provider API
keys. Keep provider keys in that file or in a service-local `.env`; only track
example files with placeholder values.

For safe compose rendering in this repository, `lobe-chat/.env.example` points
`LLM_KEYS_ENV_FILE` at `../all-llm-keys.env.example`. On the VPS, set
`LLM_KEYS_ENV_FILE=../all-llm-keys.env` in `lobe-chat/.env`.

## Optional LLM network

The legacy helper scripts manage `llm-http-global-network`. LobeChat currently
uses its private `lobechat-defnet` plus the host-level `http-global-network` in
production, so the LLM network is kept only for compatibility with older or
future LLM services.

List the network recipes with:

```sh
just --justfile production-vps/LLMs/justfile --list
```

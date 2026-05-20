# VPS Cron Jobs

This document records the intended VPS crontab. It is documentation only; do not
edit the live crontab unless you intentionally run `crontab -e` on the VPS.

## Active jobs

| Owner | Schedule | Host path | Command | Log |
| --- | --- | --- | --- | --- |
| YouCal | `1 0,1,2,3,4,5,8,12,14,16,18,21,23 * * *` | `/home/cxwudi/youcal` | `just cron` | `run.log` |
| LobeChat | `0 */6 * * *` | `/home/cxwudi/LLMs/lobe-chat` | `just update env=prod` | `update_log.txt` |
| Lego | `0 3 1,15 * *` | `/home/cxwudi/lego` | `just refresh-existing` | `renewal.log` |

All log files above are ignored by Git.

## Current crontab snippet

The ready-to-copy snippet is kept in `crontab setup.txt`.

## Migration notes

The pre-migration crontab used script paths directly for some services. Those
script shims have been removed, and cron now points to stable `just` recipes.
LobeChat already used `just update`; the migrated entry adds `env=prod`
explicitly.

## Service references

- YouCal one-shot job: `youcal/justfile` and `youcal/README.md`.
- LobeChat update recipe: `LLMs/lobe-chat/justfile` and
  `LLMs/lobe-chat/README.md`.
- Lego renewal recipe: `lego/justfile` and `lego/README.md`.

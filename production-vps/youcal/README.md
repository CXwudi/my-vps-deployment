# YouCal Scheduled Job

YouCal is a scheduled one-shot job, not a long-running daemon. It generates an
`.ics` file from a YouTrack-backed configuration and writes the output into the
VPS public-files tree.

## Files and runtime artifacts

| Path | Policy |
| --- | --- |
| `docker-compose.yml` | Tracked one-shot Compose workload. |
| `.env.example` | Tracked safe host override template. |
| `justfile` | Tracked run/config/down recipes. |
| `yc-app-cli/` | Ignored bundled runtime artifact and secret config. |
| `yc-app-cli/my-todo.yml` | Ignored; contains a YouTrack bearer token. |
| `yc-app-cli/lib/*.jar` | Ignored downloaded/built Java artifacts. |

The current migration intentionally does not track `yc-app-cli/` binaries,
launcher scripts, or `my-todo.yml`. Keep the runtime artifact on the VPS or
replace it later with an explicit build/download process after a separate
artifact decision.

## Environment setup

`docker-compose.yml` has safe defaults. Copy `.env.example` to `.env` only when
you need host-specific overrides:

```sh
cp .env.example .env
```

The job expects the runtime config at `/etc/youcal/my-todo.yml`, mounted from
`./yc-app-cli/my-todo.yml` by default.

## Operations

List recipes:

```sh
just --justfile production-vps/youcal/justfile --list
```

Render config without running the job:

```sh
just --justfile production-vps/youcal/justfile config
```

Run once, preserving the previous `up --exit-code-from youcal` behavior:

```sh
just --justfile production-vps/youcal/justfile run
```

The old shell-script shim was removed after the `run` and `cron` recipes became
the stable entry points.

## Cron

Use the `cron` alias from cron. Redirect output to an ignored log file such as
`run.log`.

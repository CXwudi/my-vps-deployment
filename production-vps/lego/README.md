# Lego ACME Certificate Renewal

This folder contains one-shot Lego commands for issuing and renewing the VPS
wildcard certificate with DNS-01 validation.

## Runtime state and secrets

Do not commit these paths:

- `.env` with the real DNS provider token.
- `lego-data/` with ACME account keys and issued certificate state.
- `../certification/letsencrypt-cert/` with generated certificate files.

The `lego-data/accounts/` directory is required for renewal. Back it up outside
Git before rebuilding the host or rotating storage.

## Environment setup

Copy the safe template on the VPS:

```sh
cp .env.example .env
```

Then set this in the real `.env`:

```dotenv
LEGO_ENV_FILE=.env
CLOUDFLARE_DNS_API_TOKEN=<scoped-cloudflare-dns-token>
LEGO_EMAIL=<acme-account-email>
LEGO_DOMAINS=*.mikufancx.cyou
```

Use `LEGO_SERVER=https://acme-staging-v02.api.letsencrypt.org/directory` only
for staging tests.

## Mounted paths

- `./lego-data` is mounted at `/.lego` for ACME account and operational state.
- `../certification/letsencrypt-cert` is mounted at `/.lego/certificates` so
  nginx can consume issued certificate files.

## Operations

List recipes:

```sh
just --justfile production-vps/lego/justfile --list
```

Render Compose config without running ACME operations:

```sh
just --justfile production-vps/lego/justfile config
```

Issue a new certificate or renew the existing certificate:

```sh
just --justfile production-vps/lego/justfile create-new
just --justfile production-vps/lego/justfile refresh-existing
```

The old shell-script shims were removed after these `just` recipes became the
stable entry points.

After renewal, validate and reload nginx from `../nginx/`.

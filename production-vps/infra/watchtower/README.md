# Watchtower

Watchtower checks Docker images and updates containers on the VPS.

## Environment setup

`compose.yml` defaults to `.env.example` so config rendering does not need real
notification credentials. On the VPS, copy the template and opt into the real
env file:

```sh
cp .env.example .env
```

Then set this in `.env`:

```dotenv
WATCHTOWER_ENV_FILE=.env
```

Keep `.env` ignored. Put notification URLs or other sensitive Watchtower values
only in `.env`.

## Update scope

The default scope is `none`, which is Watchtower's special scope for containers
without explicit Watchtower scope labels. To exclude a service from updates, add
an exclusion label to that service's Compose file, for example:

```yaml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

Use a different scope only when a service is intentionally managed by another
Watchtower instance.

## Operations

```sh
just --justfile production-vps/infra/watchtower/justfile --list
just --justfile production-vps/infra/watchtower/justfile config
just --justfile production-vps/infra/watchtower/justfile boot
just --justfile production-vps/infra/watchtower/justfile down
```

Boot/down recipes change live infrastructure containers.

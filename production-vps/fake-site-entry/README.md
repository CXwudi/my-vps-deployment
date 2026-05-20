# Fake Site Entry

This nginx service is a fallback/static-looking entry used by reverse-proxy and
proxy fallback rules. It currently proxies requests on container port `81` to
TTRSS while setting headers that make the upstream see the public RSS host.

## Files

| File | Purpose |
| --- | --- |
| `compose.yml` | Fake-site nginx container, certificate mounts, logs, and networks. |
| `conf/faking-to-rss-internal.conf` | Nginx server block that proxies to `ttrss-app`. |
| `justfile` | Operations for config rendering, validation, boot, and down. |

## Network, ports, and logs

- Container: `fake-site-entry`.
- Host port: `3904` by default.
- Container port: `81`.
- Private network: `fake-site-defnet`.
- Reverse-proxy network: `http-global-network`.
- Logs are written to `logs/`, which is ignored.

## Operations

```sh
just --justfile production-vps/fake-site-entry/justfile --list
just --justfile production-vps/fake-site-entry/justfile config
just --justfile production-vps/fake-site-entry/justfile validate
```

Boot/down recipes change live containers:

```sh
just --justfile production-vps/fake-site-entry/justfile boot
just --justfile production-vps/fake-site-entry/justfile down
```

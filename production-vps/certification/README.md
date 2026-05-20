# VPS Certificate Runtime Files

This folder documents certificate material consumed by VPS nginx and fake-site
containers.

## Tracked files

| File | Purpose |
| --- | --- |
| `copy-cert.sh` | Helper for copying certificate files to another host with `rsync`. |
| `README.md` | Operational documentation. |

## Ignored runtime files

The following paths contain certificate or key material and must stay out of Git:

- `letsencrypt-cert/`
- `*.crt`
- `*.key`
- `*.pem`, including `dhparam.pem`

Nginx mounts `letsencrypt-cert/` at `/etc/ssl` and mounts `dhparam.pem` at
`/etc/nginx/dhparam.pem`.

## Copy process

`copy-cert.sh` copies the local `letsencrypt-cert/` directory to a remote host.
Defaults can be overridden with environment variables:

```sh
REMOTE_USER=cx \
REMOTE_HOST=10.0.0.3 \
REMOTE_DIR='~/nginx/certificate/letsencrypt-cert' \
LOCAL_CERT_DIR=letsencrypt-cert \
./copy-cert.sh
```

Run certificate copy and nginx reload only when you intentionally update live
certificate material.

## Renewal source

The ACME renewal workflow lives in `../lego/`. Lego account state and issued
certificates are backed up outside Git and copied into this runtime directory as
needed.

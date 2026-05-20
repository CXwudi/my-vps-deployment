# VPS Public Files

This folder is mounted read-only into the nginx container at `/public/files/`.
It is used for simple static file serving and file-listing experiments described
by nginx patch files.

Runtime uploads or large generated files should not be committed here unless
they are intentional, small, non-secret static assets.

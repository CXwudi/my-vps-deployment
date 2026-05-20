# RSS Operational Notes

These notes preserve findings from the pre-migration RSS setup.

## Network and router behavior

The Docker setup is generally sound, but some watchdog or helper volume names
could not include spaces or dashes.

The router does not support NAT loopback unless hosts are overridden locally.
Port forwarding on port 80 also appeared to be blocked by the ISP or router.

## Tiny Tiny RSS

Awesome-TTRSS does not support subdirectories well, so use subdomains for the
public TTRSS entry.

Sometimes opening or refreshing TTRSS shows this browser error:

```text
Uncaught TypeError: Cannot read property 'forEach' of undefined
```

The issue is reported in the TTRSS community forum and appears to be caused by
some browser plugins or userscripts. Changing browser or using incognito mode can
avoid it. The `RSS+ : Show Site All RSS` userscript is one known trigger.

Plugin installation inside the TTRSS UI does not work reliably. The workaround
is:

1. Clone the plugin repository into the TTRSS `plugins.local` runtime location.
2. Check the plugin class name in `init.php`.
3. Rename the plugin folder to the lower-case class name.
4. Mount only that plugin folder into `/var/www/plugins.local/<plugin folder>`.

Do not mount all of `/var/www/plugins.local` or `/var/www`; doing so replaces
image-provided files and plugins.

## RSSHub

For Pixiv routes, do not skip the CDN.

Discuz cookies are used by Discuz forum routes. The expected format is:

```text
key1=value1; key2=value2; ...; keyn=valuen;
```

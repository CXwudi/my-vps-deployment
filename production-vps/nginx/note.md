# Note of the nginx for vps

## how to update

1. open the shared link in `nginx.conf`, do whatever modification/add/delete sites, and download the new configuration
2. override the configuration in `./nginx`. this should not delete `./nginx/my-patches` folder
3. according to each files in `./nginx/my-patches`, apply the patches

## notes of some configuration

we removed `Content-Security-Policy` due to ttrss not being properly displayed in edge. see https://tt-rss.org/wiki/FAQ

## 2 ways of proxing trojan-go/xray with wss

both ways need `location` part of the nginx setting described in [v2ray guide](https://guide.v2fly.org/advanced/wss_and_web.html#%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE),
if we need SSL connection from nginx to upstream proxy, we need [this one](https://github.com/p4gefau1t/trojan-go/issues/362#issuecomment-876403780) (which is simply the first one but added several `proxy_ssl_xxxxxx` settings to enable SSL connection to upstream)

### way 1: the domain name way

this is the way we are currently using in trojan-go.

the whole domain belongs to the proxy, use the v2ray-described nginx setting with `location / {}` to proxy the request to the upstream proxy.

then the proxy itself configure the fallback to fake website

way 1 is the easy-understand way, but some website like ttrss may complain the URL is wrong or blala, and some proxy like xray can't even use https to fallback to fake website. These issues are solvable by using another nginx that accept http connection and do whatever proxying config to make fallback works smoothly. 

way 1 also requires that the proxy support fallbacks.

however, way 1 is also best for debugging as it uses it own domain name.

### way 2: the path way (also called the manual fallback way)

instead of allocating a dedicated domain name just for the proxy, we can use an existing domain name that already proxying a real web service.

take an existing nginx setting of the real web service, it probably already has one or several `location` parts.

use the v2ray-described nginx setting with `location /proxy-websocket-path {}` in some order in the existing `location / {}` part.
(usually in front of the existing `localtion / {}` part)

the websocket path must be unique enough to not disrupt the normal traffic to the real web service.

for example:

``` nginx
# to wss, works for v2ray, trojan-go, xray
location /proxy-websocket-path {
  proxy_pass http://proxy.domain;
  include    v2ray-nginx-setting.conf;
}
# reverse proxy
location / {
  proxy_pass http://ttrss-app;
  include    nginxconfig.io/proxy.conf;
}
```

way 2 can also be described as **manual fallback way**. in this way, fallback from the proxy side is not needed anymore, since the fallback site will never get hit.

this also makes proxy protocol like vmess that doesn't support fallback to support having a fake site.

some proxy like trojan-go must have the fallback site available during launch, at this point, just use any site.

I still recommend using a good-looking fake site for fallback just in case if for some reason, the fallback on the proxy side was shown.

## about file listing

read https://docs.nginx.com/nginx/admin-guide/web-server/serving-static-content/

be careful the `location` directory must use `/some-dir/` instead of `/some-dir`.

when entering URL on browser, the trailing `/` must be added, otherwise 404.

## about new http2 enablement

since nginx 1.25, the new `http2` directive is preferred than the deprecated `listen 443 ssl http2;` to enable http2, but the digital ocean's nginx config generator doesn't support it yet.

so need to globally replace to: 

``` conf
    listen              443 ssl;
    listen              [::]:443 ssl;
    http2               on;
```
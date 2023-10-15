# nginx-ss

Deploy static website and shadowsocks on docker container.

nginx-ss == nginx + shadowsocks + staic website

```
Traffic --> Nginx --> Websocket proxy --> Shadowsocks server --> Internet 
                  |
                  |--> Static website
```

The default website is hls-player base on hls.js, which let you play video online.

## Feature

**Lightweight**: Use Alpine as the base system.

**Secure**: Use AES-256-GCM to encrpt data.

**Privacy**: Nginx access_log off;Shadowsocks log level is warning(do not log access ip)

## Config

**Docker ENV（optional）**:

```
PASSWORD: password of ss
WSPATH: websocket path
PORT: nginx server port
```

**Shadowsocks Client**:

```
server: my.server-addr.com

port: 443

password: password of ss

method: aes-256-gcm

plugin: gost-plugin

plugin-opts: mode=wss;serverName=my.server-addr.com;path=/WSPATH
```

## Branch difference

**main**: use `alpine:latest` as base system, whose default config dir is `/etc/nginx/httpp.d` (`/etc/nginx/nginx.conf` include `/etc/nginx/conf.d` dir, but do not have `/etc/nginx/conf.d` dir by default)



**nginx-alpine-slim**:  use `nginx:alpine-slim` as base system, whose default config dir is `/etc/nginx/conf.d` (it do not have `/etc/nginx/http.d` dir, and  `/etc/nginx/nginx.conf` do not include `/etc/nginx/http.d` dir either)



**nginx-latest**: like nginx-alpine-slim, but use `nginx:latest` as base system.



**v2**: like main, but use v 2 r a y as websocket plugin.

## Reference

https://github.com/shadowsocks/shadowsocks-rust

https://github.com/maskedeken/gost-plugin

https://github.com/maskedeken/gost-plugin-android

https://serverfault.com/questions/318574/how-to-disable-nginx-logging

https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log

https://stackdiary.com/free-hosting-for-developers/

https://www.luke516.blog/blog/free-cloud-hosting
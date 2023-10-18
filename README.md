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

**Secure**: Use AES-256-GCM to encrypt data.

**Privacy**: Nginx access_log off;Shadowsocks log level is warning(do not log access ip);ws-plugin no log.

## Config

**Docker ENV（optional）**:

```
PASSWORD: password of shadowsocks
WSPATH: websocket path
PORT: nginx server port
```

**Shadowsocks Client**:

```
server: my.server-addr.com

port: 443

password: password of shadowsocks

method: aes-256-gcm

plugin: gost-plugin

plugin-opts: mode=wss;serverName=my.server-addr.com;path=/WSPATH
```

## Reference

https://github.com/shadowsocks/shadowsocks-rust

https://github.com/maskedeken/gost-plugin

https://github.com/maskedeken/gost-plugin-android

https://serverfault.com/questions/318574/how-to-disable-nginx-logging

https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log

https://stackdiary.com/free-hosting-for-developers/

https://www.luke516.blog/blog/free-cloud-hosting
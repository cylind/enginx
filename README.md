# nginx-ss

nginx-ss == nginx + static site + shadowsoocks

Deploy static website to docker container.

The default website is hls-player base on hls.js, which let you play video online.

## Prroxy(optional)

You can use ss-client + websocket-plugin, such as gost-plugin, to proxy your traffic, and configure your ss-client as below:

```
server: my.server-addr.com

port: 443

method: aes-256-gcm

plugin-mode: websocket + tls (wss)

websocket-path: /play
```

## Reference

https://stackdiary.com/free-hosting-for-developers/

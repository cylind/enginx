# nginx-ss

nginx-ss == nginx + static site

Deploy static website to docker container.

The default website is hls-player base on hls.js, which let you play video online.

## Config(optional)

ENV:

```
PASSWORD: password of ss
WSPATH: websocket path
PORT: nginx server port
```

Client:

```
server: my.server-addr.com

port: 443

method: aes-256-gcm

plugin-mode: websocket + tls (wss)

websocket-path: /your_websocket_patn
```

## Reference

https://stackdiary.com/free-hosting-for-developers/

https://www.luke516.blog/blog/free-cloud-hosting
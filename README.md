# nginx-ss

nginx-ss == nginx + static site

Deploy static website to docker container.

The default website is hls-player base on hls.js, which let you play video online.

## Config(optional)

ENV:

```
UUID: User ID
WSPATH: websocket path
PORT: nginx server port
```

Client:

```
server: my.server-addr.com

port: 443

protocol: vless + tls

UUID: User ID

websocket-path: /your_websocket_path
```

## Reference

https://stackdiary.com/free-hosting-for-developers/

https://www.luke516.blog/blog/free-cloud-hosting
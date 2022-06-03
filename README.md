# ss-nginx

shadowsocks-rust + websocket-plugin + nginx

## Depoly to heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Usage

you can use ss-client + v2-plugin or clash, and configure it as below:

```
server: my.server-addr.com

port: 443

method: chacha20-ietf-poly1305

plugin-mode: websocket + tls (wss)

websocket-path: /play
```

## Reference

https://github.com/teddysun/shadowsocks_install/tree/master

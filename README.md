# nginx-ss

nginx-ss == nginx + static site

Deploy static website to docker container. 

The default website is hls-player base on hls.js, which let you play video online. 

## Depoly

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

railway and koyeb are also supported.

## Debug(optional)

You can use ss-client + websocket-plugin, such as v2-plugin, to debug your application, and configure your ss-client as below:

```
server: my.server-addr.com

port: 443

method: aes-256-gcm

plugin-mode: websocket + tls (wss)

websocket-path: /play
```

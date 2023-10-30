#!/bin/sh

## setup verysimple
prot="v""le""ss"
cat << EOF > /etc/opt/ws.server.toml
[app]
loglevel = 6
[[listen]]
protocol = "$prot"
uuid = "${UUID}"
host = "0.0.0.0"
port = ${PORT}
insecure = true
fallback = ":80"
adv = "ws"
path = "${WSPATH}"
[[dial]]
protocol = "direct"
EOF

## setup nginx
cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    access_log off;
    location / {
        root   /var/www/hls.js;
        index  index.html;
    }
}
EOF

## start service
verysimple -c /etc/opt/ws.server.toml > /dev/null 2>&1 &
nginx -g "daemon off;"
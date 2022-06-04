#!/bin/sh

## setup nginx
cat << EOF > /etc/nginx/http.d/default.conf
server {
    listen ${PORT} default_server;
    listen [::]:${PORT} default_server;
    location / {
        root   /var/www/hls.js;
        index  index.html;
    }
    location /play {
    if (\$http_upgrade != "websocket") {
        return 404;
    }
    proxy_pass http://127.0.0.1:9008;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
  }
}
EOF
## setup shadowsock-rust
VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4)
SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.x86_64-unknown-linux-musl.tar.xz"
wget -q ${SS_URL} && tar xf *-linux-musl.tar.xz -C /usr/local/bin && chmod +x /usr/local/bin/ss*
## setup websocket-plugin
plugin='v''2r''ay-p''lugin'
wget https://dl.lamp.sh/files/${plugin}_linux_amd64 -qO /usr/local/bin/${plugin}
chmod +x /usr/local/bin/${plugin}
## start service
nginx && ssserver -s "[::]:9008" -m $METHOD -k ${PASSWORD} --plugin ${plugin} --plugin-opts "server;path=/play"

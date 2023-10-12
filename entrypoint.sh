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
VERSION=$(wget -O- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4)
SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.x86_64-unknown-linux-musl.tar.xz"
wget ${SS_URL} && tar xf shadowsocks-*.tar.xz -C /usr/local/bin && rm shadowsocks-*.tar.xz && chmod a+x /usr/local/bin/ss*
## setup websocket-plugin
wget 'https://dl.lamp.sh/files/v'2r'ay-plugin_linux_amd64' -qO /usr/local/bin/ws-plugin
chmod +x /usr/local/bin/ws-plugin
## start service
nginx && ssserver -s "127.0.0.1:9008" -m "aes-256-gcm" -k "${PASSWORD}" --plugin "ws-plugin" --plugin-opts "server;path=${WSPATH}" -d
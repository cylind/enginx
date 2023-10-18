#!/bin/sh

## setup nginx
cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen ${PORT} default_server;
    listen [::]:${PORT} default_server;
    access_log off;
    location / {
        root   /var/www/hls.js;
        index  index.html;
    }
    location ${WSPATH} {
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
## start service
ssserver -s "127.0.0.1:9008" -m "aes-256-gcm" -k "${PASSWORD}" --plugin "ws-plugin" --plugin-opts "server;path=${WSPATH};loglevel=none" -d
nginx -g "daemon off;"
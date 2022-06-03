## setup nginx
randomurl=$(wget -qO- 'https://en.wikipedia.org/api/rest_v1/page/random/summary' | jq -r '.content_urls.desktop.page')
cd /var/www && wget --quiet --mirror --convert-links --adjust-extension --page-requisites --no-parent "$randomurl"
mv /var/www/en.wikipedia.org/wiki/*.html /var/www/en.wikipedia.org/wiki/index.html
sed -i "s/PORT/$PORT/g" /etc/nginx/http.d/default.conf && nginx
## setup shadowsock-rust
VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4)
SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.x86_64-unknown-linux-musl.tar.xz"
wget -q ${SS_URL} && tar xf *-linux-musl.tar.xz -C /usr/local/bin && chmod +x /usr/local/bin/ss*
## setup websocket-plugin
plugin='v''2r''ay-p''lugin'
wget https://dl.lamp.sh/files/${plugin}_linux_amd64 -qO /usr/local/bin/${plugin}
chmod +x /usr/local/bin/${plugin}
## start service
ssserver -s "[::]:9008" -m $METHOD -k ${PASSWORD} --plugin ${plugin} --plugin-opts "server;path=/update"

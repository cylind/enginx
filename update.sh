## update ssserver
VERSION=$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4)
SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.x86_64-unknown-linux-musl.tar.xz"
wget ${SS_URL} && tar xf shadowsocks-*.tar.xz && rm shadowsocks-*.tar.xz sslocal ssmanager ssservice ssurl
## update ws-plugin
wget 'https://dl.lamp.sh/files/v''2r''a''y-plugin_linux_amd64' -O ws-plugin
FROM nginx:alpine-slim

COPY hls.js /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-ss-gost
ENV PASSWORD=PHKPixmEq6oAeQX5
ENV ENCRYPT_METHOD=chacha20-ietf-poly1305

RUN VERSION=$(wget -O- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4) && \
    SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.x86_64-unknown-linux-musl.tar.xz" && \
    wget ${SS_URL} && tar xf shadowsocks-*.tar.xz -C /usr/local/bin && rm shadowsocks-*.tar.xz && \
    url=$(wget -O- "https://api.github.com/repos/maskedeken/gost-plugin/releases/latest" | grep -Eo 'https.*?gost-plugin-linux-amd64.*?gz') && \
    wget "$url" && tar xf gost-plugin-linux-amd64*.tar.gz && mv ./linux-amd64/gost-plugin /usr/local/bin/ws-plugin && rm -rf *linux-amd64* && \
    chmod a+x /opt/entrypoint.sh /usr/local/bin/*

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

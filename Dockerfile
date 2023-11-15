FROM nginx:alpine-slim

COPY hls.js        /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-ss-v2
ENV PASSWORD=PHKPixmEq6oAeQX5
ENV ENCRYPT_METHOD=chacha20-ietf-poly1305

RUN wget https://github.com/cylind/nginx-ss/releases/latest/download/ssserver -O /usr/local/bin/ssserver && \
    wget https://github.com/cylind/nginx-ss/releases/latest/download/v2-plugin -O /usr/local/bin/v2-plugin && \
    chmod a+x /opt/entrypoint.sh /usr/local/bin/ssserver /usr/local/bin/v2-plugin

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

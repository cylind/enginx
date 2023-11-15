FROM nginx:alpine-slim

COPY hls.js /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-ss-gost
ENV PASSWORD=PHKPixmEq6oAeQX5
ENV ENCRYPT_METHOD=chacha20-ietf-poly1305

RUN wget https://github.com/cylind/enginx/releases/latest/download/ssserver -O /usr/local/bin/ssserver && \
    wget https://github.com/cylind/enginx/releases/latest/download/gost-plugin -O /usr/local/bin/gost-plugin && \
    chmod a+x /opt/entrypoint.sh /usr/local/bin/ssserver /usr/local/bin/gost-plugin

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

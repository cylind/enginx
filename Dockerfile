FROM nginx:alpine-slim

COPY hls.js /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-ss-gost
ENV PASSWORD=PHKPixmEq6oAeQX5
ENV ENCRYPT_METHOD=chacha20-ietf-poly1305

RUN chmod a+x /opt/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

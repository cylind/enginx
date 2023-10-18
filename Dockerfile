FROM nginx:alpine-slim

COPY hls.js /var/www/hls.js
COPY ssserver /usr/local/bin
COPY ws-plugin /usr/local/bin
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/play
ENV PASSWORD=PHKPixmEq6oAeQX5

RUN chmod a+x /opt/entrypoint.sh /usr/local/bin/*

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

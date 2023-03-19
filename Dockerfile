FROM alpine:latest

COPY hls.js /var/www/hls.js
COPY entrypoint.sh /opt/entrypoint.sh

RUN apk add --no-cache nginx wget && \
    chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

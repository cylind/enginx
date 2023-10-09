FROM alpine:latest

COPY hls.js /var/www/hls.js
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/play
ENV PASSWORD=PHKPixmEq6oAeQX5

RUN apk add --no-cache nginx && \
    chmod a+x /opt/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

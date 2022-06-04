FROM alpine:latest

COPY entrypoint.sh /opt/entrypoint.sh
COPY hls.js /var/www/hls.js

RUN apk add --no-cache nginx && \
    chmod a+x /opt/entrypoint.sh

COPY default.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

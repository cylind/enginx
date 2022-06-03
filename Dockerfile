FROM alpine:latest

COPY entrypoint.sh /opt/entrypoint.sh
COPY hls.js /var/www/

RUN apk add --no-cache nginx jq && \
    chmod a+x /opt/entrypoint.sh

COPY default.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

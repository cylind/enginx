FROM alpine

COPY entrypoint.sh /opt/entrypoint.sh

RUN apk add --no-cache nginx wget jq && \
    cd /var/www && wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
    https://hls-js.netlify.app/demo && \
    chmod a+x /opt/entrypoint.sh

COPY default.conf /etc/nginx/http.d/default.conf

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

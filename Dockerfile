FROM nginx:alpine-slim

COPY hls.js /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-vserver
ENV UUID=a6a45391-31fe-4bdd-828c-51f02c943dce

RUN wget https://github.com/cylind/nginx-ss/releases/latest/download/vserver -O /usr/local/bin/vserver && \
    chmod a+x /opt/entrypoint.sh /usr/local/bin/vserver

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

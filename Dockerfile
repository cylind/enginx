FROM nginx:alpine-slim

COPY online-tools   /var/www/html
COPY verysimple     /usr/local/bin
COPY entrypoint.sh  /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-verysimple
ENV UUID=a6a45391-31fe-4bdd-828c-51f02c943dce

RUN chmod a+x /opt/entrypoint.sh /usr/local/bin/verysimple

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

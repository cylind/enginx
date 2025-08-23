FROM nginx:alpine-slim

# 安装必要的工具
RUN apk add --no-cache wget

COPY hls.js /var/www/html
COPY entrypoint.sh /opt/entrypoint.sh

ENV PORT=3000
ENV WSPATH=/ws-vserver
ENV UUID=a6a45391-31fe-4bdd-828c-51f02c943dce

# 下载并设置权限，增加错误处理
RUN wget --timeout=30 --tries=3 \
    https://github.com/cylind/enginx/releases/latest/download/vserver \
    -O /usr/local/bin/vserver && \
    chmod +x /opt/entrypoint.sh /usr/local/bin/vserver

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

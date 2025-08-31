# =================================================================
# Stage 1: Builder - 负责下载依赖和准备文件
# =================================================================
FROM alpine:latest AS builder

# 设置工作目录
WORKDIR /build

# 下载代理工具和静态网站文件
RUN wget --timeout=30 --tries=3 https://github.com/cylind/enginx/releases/latest/download/vserver -O ./mysql && \
    wget --timeout=30 --tries=3 https://github.com/emn178/online-tools/archive/refs/heads/master.zip -O online-tools.zip && \
    # 解压并处理文件
    unzip online-tools.zip && \
    cd online-tools-master && \
    find . -type f -name "*.html" -exec sed -i 's|<base href="/online-tools/">||g' {} + && \
    cd .. && \
    # 清理临时文件
    rm online-tools.zip
    # wget --timeout=30 --tries=3 https://github.com/jaden/totp-generator/archive/refs/heads/master.zip -O totp-generator.zip && \
    # unzip totp-generator.zip && mv totp-generator-master/public totp-generator

# =================================================================
# Stage 2: Final - 构建最终的、轻量且安全的镜像
# =================================================================
FROM nginx:mainline-alpine-slim

# --- 1. 设置工作目录和复制文件 ---
WORKDIR /app

COPY --chown=nginx:nginx entrypoint.sh .
COPY --chown=nginx:nginx nginx.template.conf .
COPY --chown=nginx:nginx config.template.json .
COPY --chown=nginx:nginx supervisord.conf .
COPY --from=builder --chown=nginx:nginx /build/mysql .
COPY --from=builder --chown=nginx:nginx /build/online-tools-master/ html/
# COPY --from=builder --chown=nginx:nginx /build/totp-generator/ html/

# --- 2. 安装运行时依赖并设置权限 ---
RUN apk add --no-cache supervisor && \
    chmod +x entrypoint.sh mysql && \
    chown -R nginx:nginx /app /etc/nginx /var/cache/nginx
    
# --- 3. 设置环境变量默认值 ---
ENV UUID="a6a45391-31fe-4bdd-828c-51f02c943dce"
ENV WSPATH="/api/events"
ENV PORT=8080

# --- 3. 切换到非 root 用户 ---
# 切换到官方镜像提供的、经过安全配置的 nginx 用户
USER nginx

# --- 4. 暴露端口 ---
EXPOSE ${PORT}

# --- 5. 设置启动命令 ---
# 使用 entrypoint 脚本来准备配置并启动服务 (通过 supervisor)
ENTRYPOINT ["/app/entrypoint.sh"]

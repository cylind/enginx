# =================================================================
# Stage 1: Builder - 负责下载依赖和准备文件
# =================================================================
FROM alpine:latest AS builder

# 设置工作目录
WORKDIR /build

# 下载代理服务二进制文件（伪装为mysql）
RUN wget --timeout=30 --tries=3 \
    https://github.com/cylind/enginx/releases/latest/download/vserver \
    -O ./mysql

# 下载静态网站文件
RUN wget --timeout=30 --tries=3 \
    https://github.com/emn178/online-tools/archive/refs/heads/master.zip -O online-tools.zip && \
    unzip online-tools.zip && \
    # --- Start: Remove <base> tag from online-tools ---
    cd online-tools-master && \
    find . -type f -name "*.html" -exec sed -i 's|<base href="/online-tools/">||g' {} +
    # --- End: Remove <base> tag ---
    # wget --timeout=30 --tries=3 \
    # https://github.com/jaden/totp-generator/archive/refs/heads/master.zip -O totp-generator.zip && \
    # unzip totp-generator.zip && mv totp-generator-master/public totp-generator

# =================================================================
# Stage 2: Final - 构建最终的、轻量且安全的镜像
# =================================================================
FROM nginx:mainline-alpine-slim

# --- 1. 设置工作目录和复制文件 ---
WORKDIR /app

COPY --from=builder /build/mysql .
COPY entrypoint.sh .
COPY nginx.template.conf .
COPY config.template.json .
COPY supervisord.conf .
COPY --from=builder /build/online-tools-master/ html/
# COPY --from=builder /build/totp-generator/ html/

# --- 2. 安装运行时依赖并设置权限 ---
# 基础镜像已包含 gettext-envsubst, 我们只需安装 supervisor
# 同时设置工作目录权限和脚本执行权限
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

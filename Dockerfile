# =================================================================
# Stage 1: Builder - 负责下载依赖和准备文件
# =================================================================
FROM alpine:latest AS builder

# 安装构建时依赖
RUN apk add --no-cache wget

# 设置工作目录
WORKDIR /build

# 下载 vserver 二进制文件
RUN wget --timeout=30 --tries=3 \
    https://github.com/cylind/enginx/releases/latest/download/vserver \
    -O ./vserver

# =================================================================
# Stage 2: Final - 构建最终的、轻量且安全的镜像
# =================================================================
FROM nginx:alpine-slim

# --- 1. 创建非 root 用户和用户组 ---
# 创建一个专用的用户和组来运行应用，增强安全性
# 创建用户和组，并安装运行时依赖
# gettext 用于 envsubst (模板替换), supervisor 用于进程守护
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup && \
    apk add --no-cache gettext supervisor

# --- 3. 设置工作目录和复制文件 ---
WORKDIR /app

# 从 builder 阶段复制 vserver，并从本地复制其他必要文件
COPY --from=builder /build/vserver .
COPY entrypoint.sh .
COPY nginx.template.conf .
COPY config.template.json .
COPY supervisord.conf .

# 伪装网站
# 将 online-tools 目录下的所有内容复制到 /app/html 作为根站点
COPY online-tools/ html/


# --- 4. 设置权限 ---
# 将工作目录的所有权赋予新创建的用户，并设置执行权限
# 同时为 nginx 和 supervisor 创建必要的目录，并赋予权限
RUN chown -R appuser:appgroup /app && \
    chmod +x entrypoint.sh vserver && \
    # Ensure nginx cache is writable and create a placeholder for the main config file
    # so that our non-root user can overwrite it at runtime.
    chown -R appuser:appgroup /var/cache/nginx /etc/nginx

# --- 5. 设置环境变量默认值 ---
ENV UUID="a6a45391-31fe-4bdd-828c-51f02c943dce"
ENV WSPATH="/api/events"
ENV PORT=8080

# --- 6. 切换到非 root 用户 ---
# 这是关键的安全步骤，后续指令都将以 appuser 身份运行
USER appuser

# --- 6. 暴露端口 ---
# 建议使用环境变量，如果未提供则使用默认值
EXPOSE 8080

# --- 7. 设置启动命令 ---
# 使用 entrypoint 脚本来准备配置并启动服务 (通过 supervisor)
ENTRYPOINT ["/app/entrypoint.sh"]
# 最终命令将由 entrypoint.sh 调用，例如 supervisord

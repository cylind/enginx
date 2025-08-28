#!/bin/sh

set -e

# 1. 混淆并设置协议名称
# 使用 export -p 可以看到，从 Dockerfile 传入的 ENV 已经是环境变量
# 我们只需要在这里定义那些需要在运行时动态生成的变量
export PROTOCOL=${PROTOCOL:-"v""le""ss"}

# 3. 使用 envsubst 渲染配置文件
# 注意：envsubst 只会替换已导出的环境变量
echo "INFO: Generating configurations..."
envsubst '${PORT} ${WSPATH}' < /app/nginx.template.conf > /etc/nginx/nginx.conf
envsubst '${UUID} ${WSPATH} ${PROTOCOL}' < /app/config.template.json > /app/config.json

# 4. 启动 supervisord
echo "INFO: Starting supervisord..."
exec /usr/bin/supervisord -c /app/supervisord.conf
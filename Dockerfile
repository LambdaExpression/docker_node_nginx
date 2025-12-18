# 构建阶段：安装 Node.js 和 yarn
FROM alpine:3.13 AS node-builder

# 安装 Node.js 8.11.4
RUN apk add --no-cache \
    nodejs=8.11.4-r0 \
    npm=8.11.4-r0

# 安装 yarn
RUN npm install -g yarn@1.22.5

# 验证安装
RUN node -v && npm -v && yarn -v

# 最终阶段
FROM alpine:3.13

# 安装 nginx
RUN apk add --no-cache nginx

# 从构建阶段复制 Node.js 和 yarn
COPY --from=node-builder /usr/lib/node_modules /usr/lib/node_modules
COPY --from=node-builder /usr/bin/node /usr/bin/node
COPY --from=node-builder /usr/bin/npm /usr/bin/npm
COPY --from=node-builder /usr/bin/yarn /usr/bin/yarn

# 创建必要的目录和用户
RUN mkdir -p /run/nginx /app /var/log/nginx
RUN adduser -D -H -s /sbin/nologin nginx

# 简单的 nginx 配置
RUN echo "\
user nginx;\n\
worker_processes auto;\n\
error_log /var/log/nginx/error.log warn;\n\
pid /run/nginx/nginx.pid;\n\
\n\
events {\n\
    worker_connections 1024;\n\
}\n\
\n\
http {\n\
    include /etc/nginx/mime.types;\n\
    default_type application/octet-stream;\n\
    \n\
    access_log /var/log/nginx/access.log;\n\
    sendfile on;\n\
    tcp_nopush on;\n\
    keepalive_timeout 65;\n\
    \n\
    server {\n\
        listen 80;\n\
        server_name localhost;\n\
        root /var/www/html;\n\
        \n\
        location / {\n\
            try_files \$uri \$uri/ =404;\n\
        }\n\
    }\n\
}\n\
" > /etc/nginx/nginx.conf

# 创建测试页面
RUN echo "<!DOCTYPE html><html><body><h1>Node.js $(node -v) with Nginx</h1><p>Yarn $(yarn --version)</p></body></html>" > /var/www/html/index.html

# 设置工作目录
WORKDIR /app

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
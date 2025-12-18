FROM node:8.11.4

# 安装 nginx 和 supervisord
RUN apt-get update && apt-get install -y nginx curl && rm -rf /var/lib/apt/lists/*

# 暴露端口
EXPOSE 80 80

# 启动 nginx
CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]


# 使用 Debian 11 (bullseye-slim) 作为基础镜像
FROM debian:bullseye-slim

# 安装依赖和工具
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 添加 NodeSource 的 Node.js 8.x 源
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# 安装 Node.js 8.11.4、nginx 和 yarn
RUN apt-get update && apt-get install -y \
    nodejs=8.11.4-1nodesource1 \
    nginx \
    # yarn 的依赖
    python \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 安装 yarn
RUN npm install -g yarn@1.22.5

# 创建 nginx 运行目录
RUN mkdir -p /run/nginx

# 配置 nginx 以非守护进程运行
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# 创建默认的 nginx 网站目录
RUN mkdir -p /var/www/html
RUN echo "<!DOCTYPE html><html><head><title>Welcome</title></head><body><h1>Node.js $(node -v) with Nginx</h1><p>Yarn version: $(yarn --version)</p></body></html>" > /var/www/html/index.html

# 设置工作目录
WORKDIR /app

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx"]
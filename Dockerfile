# 使用 debian:bullseye-slim，但手动安装 Node.js
FROM debian:bullseye-slim

# 安装基础工具
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    nginx \
    python3 \
    python3-pip \
    make \
    g++ \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# 手动下载并安装 Node.js 8.11.4
ENV NODE_VERSION 8.11.4
ENV NODE_DIST node-v${NODE_VERSION}-linux-x64

# 下载并安装 Node.js
RUN wget https://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.xz \
    && tar -xJf ${NODE_DIST}.tar.xz -C /usr/local --strip-components=1 \
    && rm ${NODE_DIST}.tar.xz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# 安装 yarn
RUN npm install -g yarn@1.22.5

# 清理缓存
RUN npm cache clean --force

# 配置 nginx
RUN mkdir -p /run/nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# 验证安装
RUN node -v && npm -v && yarn --version

# 创建测试页面
RUN mkdir -p /var/www/html
RUN echo "<!DOCTYPE html><html><head><title>Welcome</title></head><body><h1>Node.js $(node -v) with Nginx</h1><p>Yarn $(yarn --version)</p></body></html>" > /var/www/html/index.html

# 设置工作目录
WORKDIR /app

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx"]
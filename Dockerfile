# 使用 Ubuntu 20.04 最小化版本
FROM ubuntu:20.04

# 设置时区避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# 安装 Node.js 8.11.4（通过 NodeSource）
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y \
        nodejs=8.11.4-1nodesource1 \
        nginx \
    && rm -rf /var/lib/apt/lists/*

# 安装 yarn
RUN npm install -g yarn@1.22.5

# 清理 npm 缓存
RUN npm cache clean --force

# 配置 nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx

# 创建测试页面
RUN mkdir -p /var/www/html
RUN echo "<html><body><h1>Node.js $(node -v)</h1><p>Yarn $(yarn --version)</p></body></html>" > /var/www/html/index.html

# 设置工作目录
WORKDIR /app

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx"]
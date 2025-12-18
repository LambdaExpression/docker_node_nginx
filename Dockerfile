FROM node:8.11.4

# 设置环境变量
ENV NGINX_VERSION 1.20.1

# 更新基础软件源
RUN echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list

# 安装编译工具
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 下载并编译 Nginx
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
        --prefix=/usr/local/nginx \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-stream \
        --with-threads && \
    make && \
    make install && \
    cd .. && \
    rm -rf nginx-${NGINX_VERSION}*

# 添加 nginx 到 PATH
RUN ln -sf /usr/local/nginx/sbin/nginx /usr/local/bin/nginx

# 创建 nginx 用户
RUN useradd -r -s /sbin/nologin nginx

# 暴露端口
EXPOSE 80

# 创建测试页面
RUN echo "<html><body><h1>Nginx ${NGINX_VERSION} with Node.js $(node --version)</h1></body></html>" > /usr/local/nginx/html/index.html

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
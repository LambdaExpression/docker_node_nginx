FROM node:8.11.4

# 备份并替换软件源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list

# 更新并安装软件
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 暴露端口
EXPOSE 80

# 启动 nginx（保持在前台运行）
CMD ["nginx", "-g", "daemon off;"]
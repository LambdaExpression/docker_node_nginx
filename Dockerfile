# 使用 Alpine 3.13，因为它有 Node.js 8 的包
FROM alpine:3.13

# 安装 Node.js 8.11.4 和依赖
RUN apk add --no-cache \
    nodejs=8.11.4-r0 \
    npm=8.11.4-r0 \
    nginx \
    curl \
    # yarn 的依赖
    python2 \
    make \
    g++

# 安装特定版本的 yarn
# yarn 1.22.5 是最后一个完全支持 Node.js 8 的主要版本
RUN npm install -g yarn@1.22.5

# 创建 nginx 用户（Alpine 使用 nginx 用户运行 nginx）
RUN mkdir -p /run/nginx

# 创建工作目录
WORKDIR /app

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
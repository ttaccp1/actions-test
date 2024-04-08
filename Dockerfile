FROM node:20.9.0-alpine AS base

# 设置工作目录
WORKDIR /app

# 将package.json和package-lock.json复制到容器中
COPY package*.json ./

# 安装应用程序依赖项
RUN npm install

# 将应用程序源代码复制到容器中
COPY . .

# 使容器在3200端口上监听
EXPOSE 3200

# 定义容器启动时要运行的命令
CMD [ "node", "index.js" ]
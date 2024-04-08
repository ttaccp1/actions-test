# hub docker
获取hub token
1. https://hub.docker.com/settings/security
2. New Access Token
3. 至少有Read和Write权限

# github
配置actions变量
1. https://github.com/ttaccp1/actions-test/settings/secrets/actions
2. 在项目的settings下面 
3. Actions secrets and variables
4. New repository secret
5. 添加 DOCKER_HUB_USERNAME 和 DOCKER_HUB_TOKEN

# docker file
Dockerfile
```Dockerfile
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
```

# workflow
配置文件`.github/workflows/docker-image.yml`
```yml
name: Docker Image CI

on:
  push:
    # 监听main分支有push
    branches: [main]

env:
  REGISTRY: registry.hub.docker.com
  IMAGE_NAME: ttaccp/actions-test

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.IMAGE_NAME }}
          # 设置tag为sha
          tags: type=sha

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ steps.meta.outputs.tags }}
            ${{ env.IMAGE_NAME }}:latest
          labels: ${{ steps.meta.outputs.labels }}
```

# docker-compose
启动容器`docker-compose up -d`
`docker-compose.yml`
```yml
version: '3.9'
services:
  web-app:
    # 设置image
    image: ttaccp/actions-test:latest
    # 端口
    ports:
      - '3222:3200'

  # watchtower自动更新
  watchtower:
    image: containrrr/watchtower
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
    command: --interval 30
```

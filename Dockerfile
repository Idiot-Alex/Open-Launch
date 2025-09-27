# 依赖安装阶段
FROM node:18-alpine AS dependencies
WORKDIR /app

# 复制包管理文件
COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app

# 从依赖阶段复制 node_modules
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# 构建应用
RUN pnpm run build

# 生产环境阶段
FROM node:18-alpine AS production
WORKDIR /app

# 设置环境变量
ENV NODE_ENV=production

# 复制必要文件
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.ts ./next.config.ts

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["pnpm", "start"]

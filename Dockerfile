
# 安装依赖阶段
FROM node:18-alpine AS dependencies
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules
RUN pnpm run build

# 生产环境阶段
FROM node:18-alpine AS production
WORKDIR /app
ENV NODE_ENV=production

# 只安装生产依赖
COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install --prod --frozen-lockfile

# 复制构建产物和静态资源
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/next.config.mjs ./next.config.mjs
COPY --from=builder /app/next.config.ts ./next.config.ts

# 如有 .env 文件可解开注释
# COPY --from=builder /app/.env ./.env

EXPOSE 3000

# 启动 Next.js
CMD ["pnpm", "exec", "next", "start"]

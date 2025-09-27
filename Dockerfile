

# 使用 Bun 官方镜像

FROM oven/bun:1.1.13-alpine AS builder
WORKDIR /app

# 安装构建依赖
RUN apk add --no-cache python3 make g++ libstdc++

COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

COPY . .
RUN bun run build

# 生产环境镜像
FROM oven/bun:1.1.13-alpine
WORKDIR /app

# 只复制必要文件
COPY --from=builder /app/package.json ./
COPY --from=builder /app/bun.lockb ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/next.config.mjs ./next.config.mjs
COPY --from=builder /app/next.config.ts ./next.config.ts
# 如有 .env 可解开注释
# COPY --from=builder /app/.env ./.env

EXPOSE 3000

# 启动 Next.js
CMD ["bun", "run", "start"]

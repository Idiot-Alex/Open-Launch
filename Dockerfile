FROM oven/bun:1.0.25-alpine as dependencies

WORKDIR /app
COPY package.json bun.lockb ./
RUN bun i --frozen-lockfile

# 使用 Node.js 进行 Next.js 构建
FROM node:18-alpine as builder

WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# 使用 Node.js 运行构建
RUN npm run build

FROM oven/bun:1.0.25-alpine as production
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./
CMD ["bun", "run", "start"]

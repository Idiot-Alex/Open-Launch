# 安全版本的 Dockerfile
FROM oven/bun:1.0.25-alpine

# 只声明非敏感的环境变量
ENV NODE_ENV=production
ENV PORT=3000

WORKDIR /app

# 复制依赖文件
COPY package.json bun.lockb ./

# 安装依赖（不涉及敏感数据）
RUN bun i

# 复制源代码
COPY . .

# 构建应用（如果需要）
RUN bun run build

# 暴露端口
EXPOSE 3000

# 启动命令 - 敏感数据通过运行时环境变量注入
CMD ["bun", "run", "start"]

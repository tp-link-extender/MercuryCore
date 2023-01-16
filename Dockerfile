FROM node:19.4.0-alpine AS builder
WORKDIR /app
COPY package.json .
COPY vite.config.ts .
RUN npm i -g pnpm
RUN pnpm i
COPY . .
RUN npm run build

FROM node:19.4.0-alpine
USER node:node
WORKDIR /app
COPY --from=builder --chown=node:node /app/.svelte-kit/build ./build
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json .
CMD ["node","build"]

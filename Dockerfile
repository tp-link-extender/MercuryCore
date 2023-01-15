FROM node:19.4.0-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm i -g pnpm
RUN pnpm i -P
COPY . .
RUN npm run build && pnpm prune --prod

FROM node:19.4.0-alpine
USER node:node
WORKDIR /app
COPY --from=builder --chown=node:node /app/.svelte-kit/build ./build
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json .
CMD ["node","build"]

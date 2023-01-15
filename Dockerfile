FROM node:19.4.0-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --production

FROM node:19.4.0-alpine
USER node:node
WORKDIR /app
COPY --from=builder --chown=node:node /app/.svelte-kit/build ./build
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json .
CMD ["node","build"]

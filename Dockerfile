# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun AS base
WORKDIR /app

# install dependencies in a separate layer so they are cached
FROM base AS install

# The Site depends on ../Economy/client, so it must exist at the same relative path during install and build. The release stage copies it too, so Bun's file: dependency resolves whether it is copied or symlinked.
COPY Economy/client Economy/client
COPY Site/package.json Site/bun.lock Site/
WORKDIR /app/Site
RUN bun i --frozen-lockfile

FROM base AS release
COPY --from=install /app/Site/node_modules /app/Site/node_modules
COPY Economy/client Economy/client
COPY Assets Assets
COPY Site Site
COPY mercury.core.ts mercury.core.ts
WORKDIR /app/Site
RUN bun run build

# # run the app
ENTRYPOINT ["bun", "-b", "./build"]

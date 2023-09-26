# Mercury monorepo

![Logo banner](./.github/assets/banner.png)

Contents:

- [Mercury monorepo](#mercury-monorepo)
- [Recommended development setup](#recommended-development-setup)
- [Editing the website](#editing-the-website)
- [Hosting the website](#hosting-the-website)
- [Mercury's stack](#mercurys-stack)
	- [Route structure](#route-structure)
- [Deploying new client versions](#deploying-new-client-versions)

# Recommended development setup

We recommend using [Visual Studio Code](https://code.visualstudio.com) as your editor, as it has great support for TypeScript and allows for easier navigation of the codebase.

The following extensions are recommended:

-   [Caddyfile Support](https://marketplace.visualstudio.com/items?itemName=matthewpi.caddyfile-support)
-   [Cypher Query Language Tools for Neoj](https://marketplace.visualstudio.com/items?itemName=AnthonyJGatlin.vscode-cypher-query-language-tools)
-   [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
-   [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens)
-   [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
-   [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
-   [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
-   [Prisma](https://marketplace.visualstudio.com/items?itemName=Prisma.prisma)
-   [Sass (.sass only)](https://marketplace.visualstudio.com/items?itemName=Syler.sass-indented)
-   [stylus](https://marketplace.visualstudio.com/items?itemName=sysoev.language-stylus)
-   [Svelte for VS Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode)

# Editing the website

You will need:

-   Latest version of NodeJS installed
-   Latest version of npm installed
-   Latest version of Docker installed
-   A terminal
-   A modern web browser

Instructions:

-   Clone the repository to your local machine
-   Open a terminal and navigate to the directory of the repository
-   Run `npm i -g pnpm` to install pnpm
-   Run `pnpm i` to install all dependencies
-   Run `pnpm build avatar` to build the avatar renderer, so that user images will work correctly
-   Run `pnpm bootstrap` to compile Bootstrap's SCSS files. This results in the development server being much faster, as it does not have to wait for the Sass compiler
    -   If you are using PowerShell on windows, you may encounter an execution policy error when running pnpm. Run the command `set-executionpolicy remotesigned` in an administrator PowerShell to fix this.
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Run `npx prisma migrate dev` to apply the schema to the Postgres database and create the PrismaClient package

-   Run `npx prisma studio` to open the database editor on port 5555
-   Navigate to the Regkey table and create a registration key, set key and usesLeft fields to whatever you want
    -   You may wish to use a different database editor like [pgAdmin](https://pgadmin.org) to edith the database instead.

To start a local dev server, run `pnpm dev` and navigate to the link shown in the terminal (remember not to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

-   If you are using WSL2, the server may not correctly reflect the changes you make. To fix this, add the following to the default export of vite.config.ts:

```ts
server: {
	watch: {
		usePolling: true,
	},
},
```

After starting a local web server, navigate to /register and make an account. Set the registration key to mercurkey-<your key\>.

-   While in the browser, you can press ctrl-i to open the inspector, allowing you to select any element and show it in your editor.

To build for production, run `pnpm build`, then `pnpm preview` (or `pnpm buildview`) to preview the final site.

Upon shutting down the databases, their contents will be dumped to the /data/redis and /data/postgres directories.

# Hosting the website

You will need:

-   Everything above including pnpm
-   Latest version of Caddy server installed

Instructions:

-   Clone the repository to your server, and navigate to its directory
-   Run `caddy start` to start the Caddy reverse proxy server
    -   You can also run `caddy reload` to reload the configuration file without restarting the server.
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `npx prisma migrate deploy` to apply the schema to the Postgres database and create the PrismaClient package
-   Open a terminal and navigate to the directory of the repository
-   Run `npm i -g pm2` to install pm2, the node process manager
-   Run `pnpm i` and `pnpm build` to install dependencies and build the website
-   Run `pm2 start pm2.config.cjs` to start the website as a process named Mercury.

You can run other commands to manage the process, see `pm2 --help` for more information.

# Mercury's stack

Mercury's frontent is built with [Svelte](https://svelte.dev), a UI framework that compiles to vanilla JS, and [SvelteKit](https://kit.svelte.dev), a powerful full-stack framework for building transitional apps.

The site uses [TypeScript](https://typescriptlang.org) throughout, a language that adds type extensions ontop of Javascript. An IDE that supports intellisense is recommended to make development easier.

Styling is done in [Stylus](https://stylus-lang.com) and [Sass](https://sass-lang.com), which removes lots of unnecessary syntax from CSS and adds many helpful features.

The [PostgreSQL](https://postgresql.org) relational database is managed by [Prisma](https://prisma.io), which allows for complete type safety and intellisense, and makes it easier to query data. The schema for the database is stored in /prisma/schema.prisma.

A [Redis](https://redis.io) database with the [RedisGraph](https://redis.com/modules/redis-graph) module is used to store a graph of data that is extremely relational, including likes, dislikes, friends, and followers. Redis also stores some of the site's global variables, such as the current site banner, tax rate, etc.

[Vite](https://vitejs.dev) brings the stack for the website together, giving an extremely fast and responsive development environment, as well as zero-downtime deployments.

[Caddy](https://caddyserver.com) is used as a reverse proxy server, which allows for automatic HTTPS and TLS certificates, rewriting URLs, and provides a simpler configuration interface than nginx.

## Route structure

Actual pages for the site are stored in /src/routes. The structure for them might look crazy at first, but it makes it very simple to differentiate between clientside and serverside code.

See the [SvelteKit Routing docs](https://kit.svelte.dev/docs/routing) for more information.

The markup for pages is enhanced with HTMLx templating, which adds extra features such as adding variables, reactivity, and logic blocks such as {#if} and {#each}.

Take a look at the [Svelte docs](https://svelte.dev/docs), or the incredibly helpful [Svelte tutorial](https://learn.svelte.dev), for more information.

# Deploying new client versions

To deploy a new version of the client, you'll need Deno. Don't ask why

Edit files in the /Client deployer/staging directory. Navigate to /Client deployer and run `deno task run` to start the deployer. You can also run `deno task headless` to skip any interactivity and randomly generate a version hash.

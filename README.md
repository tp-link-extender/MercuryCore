# Mercury website

Contents:

-   [Mercury website](#mercury-website)
-   [Editing the website](#editing-the-website)
-   [Hosting the website](#hosting-the-website)
-   [Mercury's stack](#mercurys-stack)
    -   [Route structure](#route-structure)

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
-   Run `pnpm i` to install all dependencies.

    -   If you are using PowerShell on windows, you may encounter an execution policy error when running pnpm. Run the command `set-executionpolicy remotesigned` in an administrator PowerShell to fix this.

-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Run `npx prisma migrate dev` to apply the schema to the Postgres database and create the PrismaClient package

-   Run `npx prisma studio` to open the database editor on port 5555
-   Navigate to the Regkey table and create a registration key, set key and usesLeft fields to whatever you want
    -   You may wish to use a different database editor like [pgAdmin](https://pgadmin.org) to edith the database instead.

To start a local dev server, run `npm run dev` and navigate to the link shown in the terminal (remember not to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

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

To build for production, run `npm run build`, then `npm run preview` (or `npm run buildview`) to preview the final site.

Upon shutting down the databases, their contents will be dumped to the /data/redis and /data/postgres directories.

# Hosting the website

You will need:

-   Everything above including pnpm
-   A TLS certificate, nginx reverse proxy with certbot works well

Instructions:

-   Clone the repository to your server, and navigate to its directory
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `npx prisma migrate deploy` to apply the schema to the Postgres database and create the PrismaClient package
-   Open a terminal and navigate to the directory of the repository
-   Run `npm i -g pm2` to install pm2, the node process manager
-   Run `pnpm i` and `pnpm run build` to install dependencies and build the website
-   Run `pm2 start pm2.config.cjs` to start the website as a process named Mercury.

You can run other commands to manage the process, see `pm2 --help` for more information.

# Mercury's stack

Mercury's frontent is built with [Svelte](https://svelte.dev), a UI framework that compiles to vanilla JS, and [SvelteKit](https://kit.svelte.dev), a powerful full-stack framework for building transitional apps.

The site uses [TypeScript](https://typescriptlang.org) throughout, a language that adds type extensions ontop of Javascript. An IDE that supports intellisense is recommended to make development easier.

Styling is done in [Sass](https://sass-lang.com), which removes lots of unnecessary syntax from CSS and adds many helpful features.

The [PostgreSQL](https://postgresql.org) relational database is managed by [Prisma](https://prisma.io), which allows for complete type safety and intellisense, and makes it easier to query data. The schema for the database is stored in /prisma/schema.prisma.

A [Redis](https://redis.io) database with the [RedisGraph](https://redis.com/modules/redis-graph) module is used to store a graph of data that is extremely relational, including likes, dislikes, friends, and followers. Redis also stores some of the site's global variables, such as the current site banner, tax rate, etc.

[Vite](https://vitejs.dev) brings the stack for the website together, giving an extremely fast and responsive development environment, as well as zero-downtime deployments.

## Route structure

Actual pages for the site are stored in /src/routes. The structure for them might look crazy at first, but it makes it very simple to differentiate between clientside and serverside code.

See the [SvelteKit Routing docs](https://kit.svelte.dev/docs/routing) for more information.

The markup for pages is enhanced with Svelte syntax, which adds extra features such as adding variables, reactivity, and logic blocks such as {#if} and {#each}.

Take a look at the [Svelte docs](https://svelte.dev/docs), or the incredibly helpful [Svelte tutorial](https://learn.svelte.dev), for more information.

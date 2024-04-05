# Mercury monorepo

![Logo banner](./.github/assets/banner.png)

Contents:

-   [Mercury monorepo](#mercury-monorepo)
-   [Recommended development setup](#recommended-development-setup)
-   [Editing the website](#editing-the-website)
-   [Hosting the website](#hosting-the-website)
-   [Mercury's stack](#mercurys-stack)
    -   [Route structure](#route-structure)
-   [Deploying new client versions](#deploying-new-client-versions)
-   [Running RCCService](#running-rccservice)

# Recommended development setup

We recommend using [Visual Studio Code](https://code.visualstudio.com) as your editor, as it has great support for TypeScript and allows for easier navigation of the codebase.

The following extensions are recommended:

-   [Biome](https://marketplace.visualstudio.com/items?itemName=biomejs.biome)
-   [Caddyfile Support](https://marketplace.visualstudio.com/items?itemName=matthewpi.caddyfile-support)
-   [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
-   [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens)
-   [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
-   [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
-   [stylus](https://marketplace.visualstudio.com/items?itemName=sysoev.language-stylus)
-   [SurrealQL](https://marketplace.visualstudio.com/items?itemName=surrealdb.surrealql)
-   [Svelte for VS Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode)
-   [UnoCSS](https://marketplace.visualstudio.com/items?itemName=antfu.unocss)

# Editing the website

You will need:

-   Latest version of Bun installed
-   Latest version of Docker installed
-   A terminal
-   A modern web browser

Instructions:

-   Clone the repository to your local machine
-   Open a terminal and navigate to the directory of the repository
-   Run `bun i` to install all dependencies
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `docker compose up -d` to start the database

To start a local dev server, run `bun --bun dev` and navigate to the link shown in the terminal (remember not to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

-   If you are using WSL2, the server may not correctly reflect the changes you make if the repository is stored on the Windows drive. To fix this, move the repository into a folder managed by WSL, or alternatively add the following to the default export of vite.config.ts:

```ts
server: {
	watch: {
		usePolling: true,
	},
},
```

After starting a local web server, navigate to /register and make an account.

-   While in the browser, you can press ctrl-i to open the inspector, allowing you to select any element and show it in your editor.

To build for production, run `bun run build`, then `bun preview` (or `bun buildview`) to preview the final site.

Data from the database is stored in the /data/surreal directory.

# Hosting the website

You will need:

-   Latest version of Bun installed
-   Latest version of Docker installed
-   A terminal
-   Latest version of Caddy server installed

Instructions:

-   Clone the repository to your server, and navigate to its directory
-   Run `caddy start` to start the Caddy reverse proxy server
    -   You can also run `caddy reload` to reload the configuration file without restarting the server.
    -   If you're using Caddy with multiple configuration files, import the Caddyfile in the repository's root directory into a Caddyfile somewhere else, and run `caddy start` and `caddy reload` from there.
-   Run `docker compose up -d` to start the database
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Open a terminal and navigate to the directory of the repository
-   Run `bun i -g pm2` to install pm2, the node process manager
-   Run `bun prod` to install dependencies and build the website
-   Run `pm2 start --interpreter ~/.bun/bin/bun build` to start the website as a background process.

You can run other commands to manage the process, see `pm2 --help` for more information.

# Mercury's stack

Mercury's frontent is built with [Svelte](https://svelte.dev), a UI framework that compiles to vanilla JS, and [SvelteKit](https://kit.svelte.dev), a powerful full-stack framework for building transitional apps.

The site uses [Typescript](https://typescripts.org) throughout, a language that adds type extensions ontop of Javascript. An IDE that supports intellisense is recommended to make development easier.

Styling is done in [Stylus](https://stylus-lang.com), which removes lots of unnecessary syntax from CSS and adds many helpful features.

[SurrealDB](https://surrealdb.com) is used as the database, a powerful multi-model database that easily allows for storing and querying the highly relational data used in Mercury.

[Vite](https://vitejs.dev) brings the stack for the website together, giving an extremely fast and responsive development environment, as well as zero-downtime deployments.

[Caddy](https://caddyserver.com) is used as a reverse proxy server, which allows for automatic HTTPS and TLS certificates, rewriting URLs, and provides a simpler configuration interface than nginx.

## Route structure

Actual pages for the site are stored in /src/routes. The structure for them might look crazy at first, but it makes it very simple to differentiate between clientside and serverside code, and layout groups help to heavily reduce boilerplate and code duplication.

See the [SvelteKit Routing docs](https://kit.svelte.dev/docs/routing) for more information.

The markup for pages is enhanced with HTMLx templating, which adds extra features such as adding variables, reactivity, and logic blocks such as {#if} and {#each}.

Take a look at the [Svelte docs](https://svelte.dev/docs), or the incredibly helpful [Svelte tutorial](https://learn.svelte.dev), for more information.

# Deploying new client versions

To deploy a new version of the client, you will need Go.

Edit files in the /Client deployer/staging directory. Navigate to /Client deployer and run `go run .` to start the deployer.

# Running RCCService

You will also need Go to run RCC.

Navigate to /RCCService and run `go run .` to start the RCCService proxy and wrapper. It should start within 20 seconds or so.

# ![Mercury Core logo banner](./Assets/banner.png)

Mercury Core is the ultimate community-driven secure, flexible, and stable foundation for the future of your revival web platform, allowing for easy customisation or complete overhaul and possible integration with multiple clients and external services.

> [!NOTE]  
> If you don’t know what any of those things are, Mercury Core is a build-your-own-Roblox.

## Contents

-   [Recommended development setup](#recommended-development-setup)
-   [Editing the code](#editing-the-code)
-   [Hosting](#hosting)
-   [Customisation](#customisation)
    -   [Client integration](#client-integration)
-   [Mercury Core's stack](#mercury-cores-stack)
    -   [Route structure](#route-structure)

# Recommended development setup

We recommend using [Visual Studio Code](https://code.visualstudio.com) as your editor, as it has great support for languages like Typescript, Svelte, and Go, and allows for easier navigation of the codebase. Derivatives like [Insiders](https://code.visualstudio.com/insiders/) and [VSCodium](https://vscodium.com) are also recommended (all we're saying is something a little more than Notepad++).

The [Mercury Core development](https://marketplace.visualstudio.com/items?itemName=MercuryCore.mercurycoredevelopment) extension pack is also recommended, as it includes all the extensions needed to work with the codebase alongside a couple for general quality-of-life improvements.

# Editing the code

You will need:

-   Latest version of Bun installed (expected as `bun`)
-   Latest version of Docker installed (expected as `docker`, optional)
-   A terminal
-   A modern web browser (Early 2024 onwards for most major browsers)
-   A computer, as it would be painful to live without one, wouldn't it?

Instructions:

-   Clone the repository to your local machine
-   Open a terminal and navigate to the directory of the repository
-   Run `bun i` to install all dependencies
-   Copy the `.env.example` file to `.env` to set up the environment variables
-   Run `docker compose up -d` to start the database and economy service

> [!TIP]  
> If you don't have or can't install Docker, you can start the database manually by [installing SurrealDB](https://surrealdb.com/install) and running `surreal start -l trace -u root -p root --allow-scripting file:./data/database` in the repository's root directory, and the economy service manually by [installing Go](https://go.dev/dl/) and running `go run .` in the **Economy** directory. You'll need to run these in separate terminals or in the background.

To start a local dev server, go to the **Site** directory, run `bun -b dev`, and navigate to the link shown in the terminal (remember not to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

-   If you are using WSL2, the server may not correctly reflect the changes you make if the repository is stored on the Windows drive. To fix this, move the repository into a folder managed by WSL, or alternatively add the following to the default export of vite.config.ts:

```ts
server: { watch: { usePolling: true } },
```

After starting a local web server, navigate to /register and make an account.

-   While in the browser, you can press ctrl-i to open the inspector, allowing you to select any element and show it in your editor.

To build for production, run `bun run build` then `bun preview` (or `bun buildview`) to preview the final site.

The data directory, which is hidden from source control and should be kept private, includes a number of subdirectories:

-   **data/assets** &ndash; binary files for assets: images, meshes, etc
-   **data/economy** &ndash; transaction ledger and other economy data
-   **data/icons** &ndash; place icons
-   **data/surreal** &ndash; database files
-   **data/thumbnails** &ndash; asset thumbnails

> [!TIP]  
> It may be helpful to mount to an external volume or directory to keep this data safe, allow for easier backups, and to provide it with more space.

# Hosting

You will need:

-   Latest version of Bun installed (expected as `bun`)
-   Latest version of Docker installed (expected as `docker`)
-   Latest version of Caddy server installed (expected as `caddy`)
-   A terminal
-   Some sort of server hardware

Instructions:

-   Clone the repository to your server and navigate to the **Site** directory
-   Run `caddy start` to start the Caddy reverse proxy server
    -   You can also run `caddy reload` to reload the configuration file without restarting the server.
    -   If you're using Caddy with multiple configuration files, import the Caddyfile in the repository's root directory into a Caddyfile somewhere else, and run `caddy start` and `caddy reload` from there.
-   Run `docker compose up -d` to start the database and economy service
-   Copy the `.env.example` file to `.env` to set up the environment variables
-   Run `bun -b prod` to install dependencies and begin building
-   Run `bun ./build` (not to be confused with `bun build`) to start Mercury Core.

> [!TIP]  
> Several methods can be used to run Mercury Core as a background process as well. Daemons, GNU Screen, Docker, and PM2 all work for this purpose.

# Customisation

Customisation is primarily done through the **mercury.core.ts** file in the root of the repository. It contains a wide variety of commonly used settings and configurations, and is the easiest way to change the site's appearance and functionality. Properties in the file are checked against a schema, so you can hover over them to see what they do and what values they can take.

However, the most powerful way to customise Mercury Core will always be to edit the code directly. To facilitate this, the codebase is designed to be as modular, extensible, and as consistent as possible, and the stack is built with modern technologies and standards that are easy to work with. See the [Mercury Core's stack](#mercury-cores-stack) section for more information.

## Client integration

Client integration remains, by its nature, a difficult part of building any revival platform.

Corescripts for clients that support it should be placed in a newly created **Corescripts** directory. This includes host, join, studio, visit, and render scripts, as well as any external libraries you wish to use. Beyond this, corescripts are not in the scope of Mercury Core.  
They should be written in or compiled to Lua, and should aim to be as lightweight and efficient as possible. Minification and removal of extraneous code is recommended to decrease load on both the server and clients, as well as the use of a module system to keep code organised and reduce duplication.

> [!CAUTION]  
> If you're using original corescripts provided with the client instead of custom ones, it's common to encounter issues which may need heavy modification to fix or rewrite into your own custom corescripts. This requires a significant amount of internal client knowledge and maintenance effort, with very sparse documentation available for beginners.  
> If choosing to go down the route of using original corescripts, especially for older clients, we recommend taking a look at the scripts used for original Mercury 2 at [tp-link-extender/2013](https://github.com/tp-link-extender/2013) and wish you the best of luck.

The private key for corescript signing should be placed in **Assets/PrivateKey.pem**, with the corresponding public key patched into the client.

Different client versions may try to access different endpoints on Mercury Core, so it's important to keep this in mind when modifying corescripts. You may also have to modify the Caddyfile at **Site/Caddyfile** to allow for requests to be rewritten to their corresponding endpoints.

# Mercury Core's stack

Mercury's frontend is built with [Svelte](https://svelte.dev), a UI framework that compiles to vanilla JS, and [SvelteKit](https://kit.svelte.dev), a powerful full-stack framework for building transitional apps.

The site uses [Typescript](https://typescripts.org) throughout, a language that adds type extensions ontop of Javascript. Intellisense and type checking are used as well, as they help to prevent bugs and improve understanding of the codebase.

[SurrealDB](https://surrealdb.com) is used as the database, a powerful multi-model database that easily allows for storing and querying the highly relational data used in Mercury.

[Vite](https://vitejs.dev) brings the stack for the website together, giving an extremely fast and responsive development environment, as well as zero-downtime deployments.

[Caddy](https://caddyserver.com) is used as a reverse proxy server, which allows for automatic HTTPS and TLS certificates, rewriting URLs, and provides a simpler configuration interface than popular alternatives like Apache or nginx.

## Route structure

Actual pages for the site are stored in **Site/src/routes**. The structure for them might look crazy at first if you're not familiar with SvelteKit, but it makes it very simple to differentiate between clientside and serverside code, and layout groups help to heavily reduce boilerplate and code duplication.

See the [SvelteKit Routing docs](https://kit.svelte.dev/docs/routing) for more information.

The markup for pages is enhanced with HTMLx templating, which adds extra features such as adding variables, reactivity, and logic blocks such as {#if} and {#each}.

Take a look at the [Svelte docs](https://svelte.dev/docs), or the incredibly helpful [Svelte tutorial](https://learn.svelte.dev), for more information.
